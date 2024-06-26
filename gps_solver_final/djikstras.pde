void drawPath() {
  fill(0, 0, 255);
  for (int i = 0; i <= step; i++) {
    PVector p = path.get(i);
    square(p.x * maze.cellSize, p.y * maze.cellSize, maze.cellSize);
  }
}

ArrayList<PVector> dijkstra() {
  for (int i = 0; i < maze.cols; i++) {
    for (int j = 0; j < maze.rows; j++) {
      maze.dist[i][j] = Integer.MAX_VALUE;
      //maze.visited[i][j] = false;
    }
  }
  maze.dist[(int) maze.start.x][(int) maze.start.y] = 0;

  while (true) {
    PVector u = minDistance(maze.dist, maze.visited);
    if (u == null || u.equals(maze.end)) break;

    int ux = (int) u.x;
    int uy = (int) u.y;
    maze.visited[ux][uy] = true;

    for (PVector neighbor : getNeighbors(u)) {
      int nx = (int) neighbor.x;
      int ny = (int) neighbor.y;

      // Add bounds check to prevent IndexOutOfBoundsException
      if (nx < 0 || nx >= maze.cols || ny < 0 || ny >= maze.rows) continue;

      if (maze.visited[nx][ny]) continue;

      int alt = maze.dist[ux][uy] + 1;
      if (alt < maze.dist[nx][ny]) {
        maze.dist[nx][ny] = alt;
        maze.prev[nx][ny] = u;
      }
    }
    redraw(); // Redraw the canvas after each step
  }

  return reconstructPath(maze.prev);
}


PVector minDistance(int[][] dist, boolean[][] visited) {
  int min = Integer.MAX_VALUE;
  PVector minIndex = null;

  for (int i = 0; i < maze.cols; i++) {
    for (int j = 0; j < maze.rows; j++) {
      if (!visited[i][j] && dist[i][j] < min) {
        min = dist[i][j];
        minIndex = new PVector(i, j);
      }
    }
  }
  return minIndex;
}

ArrayList<PVector> getNeighbors(PVector u) {
  int ux = (int) u.x;
  int uy = (int) u.y;
  ArrayList<PVector> neighbors = new ArrayList<PVector>();
  if (isValid(ux - 1, uy)) neighbors.add(new PVector(ux - 1, uy));
  if (isValid(ux + 1, uy)) neighbors.add(new PVector(ux + 1, uy));
  if (isValid(ux, uy - 1)) neighbors.add(new PVector(ux, uy - 1));
  if (isValid(ux, uy + 1)) neighbors.add(new PVector(ux, uy + 1));
  return neighbors;
}


boolean isValid(int x, int y) {
  return x >= 0 && x < maze.cols && y >= 0 && y < maze.rows && maze.grid[x][y].state == 0;
}

ArrayList<PVector> reconstructPath(PVector[][] prev) {
  ArrayList<PVector> path = new ArrayList<PVector>();
  PVector current = maze.end;

  while (current != null) {
    path.add(current);
    int x = (int) current.x;
    int y = (int) current.y;
    current = prev[x][y];
  }

  ArrayList<PVector> reversedPath = new ArrayList<PVector>();
  for (int i = path.size() - 1; i >= 0; i--) {
    reversedPath.add(path.get(i));
  }

  return reversedPath;
}
