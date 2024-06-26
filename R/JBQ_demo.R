
test_all <- function() {
  jbq_obj <- JBQ$new("C:\\Users\\liangh\\Desktop\\BioConnect_Data\\JAXDP00007S")

  jbq_obj$show_studies()

  study_sources <- jbq_obj$get_study_sources()
  View(study_sources)

  assay_samples = jbq_obj$get_assay_samples()
  View(assay_samples)

  assay_source_samples <- jbq_obj$get_assay_sources_samples()
  View(assay_source_samples)

  jbq_obj$show_files()

  jbq_obj$get_files("*raw*")
}

