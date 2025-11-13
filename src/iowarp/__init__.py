"""
IOWarp - A wrapper package for IOWarp components

This package installs both iowarp-agent-toolkit and iowarp-core.
"""

from importlib.metadata import version, PackageNotFoundError

try:
    __version__ = version("iowarp")
except PackageNotFoundError:
    # Package is not installed
    __version__ = "0.0.0.dev0"

# Try to import the underlying packages to verify they're installed
try:
    import iowarp_agent_toolkit
except ImportError:
    pass

try:
    import iowarp_core
except ImportError:
    pass
