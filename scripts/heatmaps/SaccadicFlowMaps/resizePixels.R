resizePixels = function(im, w, h) {
  pixels = as.vector(im)
  # initial width/height
  w1 = nrow(im)
  h1 = ncol(im)
  # target width/height
  w2 = w
  h2 = h
  # Create empty vector
  temp = vector('numeric', w2*h2)
  # Compute ratios
  x_ratio = w1/w2
  y_ratio = h1/h2
  # Do resizing
  for (i in 0:(h2-1)) {
    for (j in 0:(w2-1)) {
      px = floor(j*x_ratio)
      py = floor(i*y_ratio)
      temp[(i*w2)+j] = pixels[(py*w1)+px]
    }
  }
  
  m = matrix(temp, h2, w2)
  return(m)
}