c = get_config()

# c.TerminalInteractiveShell.highlighting_style = "default"
c.TerminalInteractiveShell.colors = "Linux"
c.TerminalInteractiveShell.editor = "vim"

c.InteractiveShell.ast_node_interactivity = "all"

c.InteractiveShellApp.exec_lines = [
    "import pandas as pd",
    "pd.set_option('display.max_columns', 100)",
]

from traitlets.config import get_config

c = get_config()
