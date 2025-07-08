local user = vim.env.USER or "User"

local local_host = "localhost" -- "100.91.131.3"

return {
    {
        "zbirenbaum/copilot.lua",
        lazy = true,
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            copilot_model = "gpt-4o-copilot",
            panel = { enabled = false },
            suggestion = {
                enabled = false,
                keymap = {
                    accept = false,
                }
            },
            filetypes = {
                markdown = true,
                help = true,
            },
        },
    },

    {
        "CopilotC-Nvim/CopilotChat.nvim",
        lazy = true,
        build = "make tiktoken",
        dependencies = { { "zbirenbaum/copilot.lua" }, { "nvim-lua/plenary.nvim", branch = "master" } },
        branch = "main",
        opts = {
            model = "gpt-4.1",
            user = user:sub(1, 1):upper() .. user:sub(2),
            question_header = " " .. user .. " ",
            answer_header = " Copilot ",
            auto_insert_mode = false,
            debug = false,
            auto_follow_cursor = false,
            window = {
                width = 0.4,
            },
            sticky = {
                '#buffers',
            },
            providers = {
                lmstudio = {
                    -- prepare_input = require('CopilotChat.config.providers').copilot.prepare_input,
                    -- prepare_output = require('CopilotChat.config.providers').copilot.prepare_output,
                    prepare_input = function(inputs, opts)
                        -- Use copilot's prepare_input logic
                        local is_o1 = vim.startswith(opts.model.id, 'o1')

                        inputs = vim.tbl_map(function(input)
                            if is_o1 then
                                if input.role == 'system' then
                                    input.role = 'user'
                                end
                            end
                            return input
                        end, inputs)

                        local out = {
                            messages = inputs,
                            model = opts.model.id,
                        }

                        if not is_o1 then
                            out.n = 1
                            out.top_p = 1
                            out.stream = true
                            out.temperature = opts.temperature
                        end

                        if opts.model.max_output_tokens then
                            out.max_tokens = opts.model.max_output_tokens
                        end

                        return out
                    end,

                    prepare_output = function(output)
                        local message
                        if output.choices and #output.choices > 0 then
                            message = output.choices[1]
                        else
                            message = output
                        end

                        local content = message.message and message.message.content or
                            message.delta and message.delta.content
                        local usage = message.usage and message.usage.total_tokens or
                            output.usage and output.usage.total_tokens
                        local finish_reason = message.finish_reason or message.done_reason or output.finish_reason or
                            output.done_reason

                        return {
                            content = content,
                            finish_reason = finish_reason,
                            total_tokens = usage,
                            references = {},
                        }
                    end,

                    get_models = function(headers)
                        local response, err = require('CopilotChat.utils').curl_get(
                            'http://' .. local_host .. ':1234/v1/models',
                            {
                                headers = headers,
                                json_response = true
                            })

                        if err then
                            error(err)
                        end

                        return vim.tbl_map(function(model)
                            return {
                                id = model.id,
                                name = model.id,
                            }
                        end, response.body.data)
                    end,

                    embed = function(inputs, headers)
                        local response, err = require('CopilotChat.utils').curl_post(
                            'http://' .. local_host .. ':1234/v1/embeddings', {
                                headers = headers,
                                json_request = true,
                                json_response = true,
                                body = {
                                    dimensions = 512,
                                    input = inputs,
                                    model = 'text-embedding-nomic-embed-text-v1.5',
                                },
                            })

                        if err then
                            error(err)
                        end

                        return response.body.data
                    end,

                    get_url = function()
                        return 'http://' .. local_host .. ':1234/v1/chat/completions'
                    end,
                },
            },

            prompts = {
                Doc = {
                    prompt =
                    "> #buffer \n Please add high quality documentation to the code. Add tickmarks around all parameters and variables to prevent escape characters and to ensure lsps properly format them. ",
                },
                Fix = {
                    prompt =
                    "> #buffer \n There is a problem in the selected code. Rewrite the code to show it with the bug fixed. If a line diagnostic is provided then display the diagnostic to the user.",
                },
                Refactor = {
                    prompt =
                    "> #buffer \n Refactor the following file to improve readability, maintainability, and performance while ensuring its functionality remains the same. Apply best practices, optimize for efficiency. Make sure to adhere to standards and use descriptive variable names. Additionally, suggest any potential improvements that were not implemented but could be valuable in the future.",
                },

                RefactorAll = {
                    prompt =
                    "> #buffers \n Refactor the following files to improve readability, maintainability, and performance while ensuring its functionality remains the same. Apply best practices, optimize for efficiency. Make sure to adhere to standards and use descriptive variable names. Additionally, suggest any potential improvements that were not implemented but could be valuable in the future.",
                },
                Performance = {
                    prompt =
                    "> #buffers \n Refactor the following files to improve performance while ensuring its functionality remains the same. Apply best practices, optimize for efficiency. Make sure to adhere to standards and use descriptive variable names.",
                },
            },
        },
        keys = {
            { "<leader>cm", "<cmd>CopilotChatModels<cr>", mode = { "n", "v" }, desc = "Change CopilotChat Model" },
            { "<leader>cc", "<cmd>CopilotChatToggle<cr>", mode = { "n", "v" }, desc = "Toggle Chat Window" },
            {
                "<leader>cq",
                function()
                    local input = vim.fn.input("Quick Chat: ")
                    if input ~= "" then
                        local mode = vim.fn.mode()
                        local selection_type = (mode == "v" or mode == "V" or mode == "\22")
                            and require("CopilotChat.select").visual
                            or require("CopilotChat.select").buffer
                        require("CopilotChat").ask(input, { selection = selection_type })
                    end
                end,
                mode = { "n", "v" },
                desc = "CopilotChat - Quick chat",
            },
            {
                "<leader>ca",
                function()
                    local actions = require("CopilotChat.actions")
                    require("CopilotChat.integrations.snacks").pick(actions.prompt_actions())
                end,
                mode = { "n", "v" },
                desc = "CopilotChat - Prompt actions",
            },
        },
    },
}
