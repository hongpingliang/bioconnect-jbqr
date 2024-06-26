context("test JBQ class")
library(here)

# test that requires sourcing the files under test
pkg_path <- here("R")
for (f in list.files(pkg_path)) {
  source(file.path(pkg_path, f))
}

jbq_obj <- JBQ$new("C:\\Users\\liangh\\Desktop\\BioConnect_Data\\JAXDP00007S")

test_that("test show study", {
  jbq_obj$show_studies()
})

test_that("test show file", {
  jbq_obj$show_files()
})

test_that("test get file with the word 'raw'", {
  jbq_obj$get_files("*raw*")
})

