# Global workspace rules

## Temporary files

- Put temporary plans and disposable helper scripts in the current working directory's `.local/` directory.
- Before creating them, run `"$PI_CODING_AGENT_DIR/scripts/check-local.sh"` from the working directory. If it fails, run `"$PI_CODING_AGENT_DIR/scripts/create-local.sh"`.
- Keep requested deliverables and permanent project files in their normal project locations, not `.local/`.
