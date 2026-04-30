display: workspaces:
  map (n: {
    workspace = toString n;
    output = display.name;
  })
  workspaces
