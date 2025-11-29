test_that("plot_to_img_content is an S3 generic", {
  expect_true(is.function(plot_to_img_content))
})

test_that("explain_plot function exists and has correct signature", {
  expect_true(is.function(explain_plot))
  args <- names(formals(explain_plot))
  expect_true("chat" %in% args)
  expect_true("p" %in% args)
  expect_true("session" %in% args)
})
