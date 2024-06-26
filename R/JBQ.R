library(stringr)
library(logger)
log_threshold(DEBUG)

#' The JBQ | JAX BioConnect Query tool
#'
#' Class \code{JBQ} wraps a JBQ functions
#'
#' @name JBQ-class
#' @rdname JBQ-class
#' @exportClass JBQ
#'
#'
#' Example to use this class
#'   jbq_obj = JBQ$new("JAXDP00006X")
#'   jbq_obj <- JBQ$new("C:\\Users\\liangh\\Desktop\\BioConnect_Data\\JAXDP00007S")
#'   jbq_obj$show_studies()
#'
#'   study_sources <- jbq_obj$get_study_sources()
#'   View(study_sources)
#'
#'   assay_samples = jbq_obj$get_assay_samples()
#'   View(assay_samples)
#'
#'   assay_source_samples <- jbq_obj$get_assay_sources_samples()
#'   View(assay_source_samples)
#'
#'   jbq_obj$show_files()
#'   jbq_obj$get_files("*raw*")
#'
#'
#'
#' @export
JBQ = R6::R6Class(
  "JBQ",
  portable = FALSE,
  class = FALSE,
  cloneable = FALSE,

  #' @description
  #' private fields
  private = list(
  ),

  public = list(
    #' @field path_to_file_or_dir character, File path to a .zip file or an uncompressed directory
    path_to_file_or_dir = NULL,

    #' @description
    #' Initialization method.
    #' @param path_to_file_or_dir character. File path to a .zip file or an uncompressed directory
    initialize = function(
      path_to_file_or_dir = NULL
    ) {

      log_info("Version: {get_version()}")
      self$path_to_file_or_dir = path_to_file_or_dir
    },

    #' @description
    #' show_studies, show studies
    #'
    #' @return character, output
    show_studies = function() {
      optional = "--show study"
      output = self$read_package(optional)
      output
    },

    #' @description
    #' show_files, show files
    #'
    #' @return character, output
    show_files = function() {
      optional = "--show file"
      output = self$read_package(optional)
      output
    },

    #' @description
    #' get_assay_samples, get assay samples
    #'
    #' @return dataframe
    get_assay_samples = function() {
      optional = "--show assay --samples"
      output = self$read_package(optional)
      df = self$parse(output, 'samples')
      df
    },

    #' @description
    #' get_assay_sources_samples, get assay sources samples
    #'
    #' @return dataframe
    get_assay_sources_samples = function() {
      optional = "--show assay --sources-samples"
      output = self$read_package(optional)

      df = self$parse(output, 'sources-samples')
      df
    },

    #' @description
    #' get_study_sources, get study sources
    #'
    #' @return dataframe
    get_study_sources = function() {
      optional = "--show study --sources"
      output = self$read_package(optional)
      df = self$parse(output, 'sources')
      df
    },

    #' @description
    #' get_files, download files
    #'
    #' @param file_name_filter character. file name filter, "all" for all file
    #' @return character, output
    get_files = function(file_name_filter) {
      operation <- paste0(self$path_to_file_or_dir, " --task-id -1 --get-files ", file_name_filter)
      output = self$jbq_command("read package", operation)
      output
    },

    #' @description
    #' get_jbq_version, get jbq version
    #'
    #' @return dataframe
    jbq_version = function() {
      output <- self$jbq_command(command='version')
      output
    },

    #' @description
    #' read, do a system call with a operation and return the call output
    #'
    #' @param command character. JBQ command
    #' @param optional character. JBQ optional
    #' @return character vector, the output of the system JBQ call
    read_package = function(
    optional = NULL
    ) {
      operation <- paste0(self$path_to_file_or_dir, " --format csv_file ", optional)
      output <- self$jbq_command("read package", operation)
      output
    },

    #' @description
    #' system_call, do a system call with a operation and return the call output
    #'
    #' @param command character. JBQ command
    #' @param operation character. JBQ operation
    #' @return character vector, the output of the system JBQ call
    jbq_command = function(
    command = NULL,
    operation = NULL
    ) {
      cmd = paste0("jbq", " ", command, " ", operation)
      log_debug("cmd: {cmd}")
      output <- system(cmd, intern=TRUE)
      output
    },

    #' @description
    #' parse, parse the system call output to dataframe
    #'
    #' @param output character. system call output
    #' @param data_tag character. data tag
    #' @return dataframe, parsed the dataframe from the output
    parse = function(
    output,
    data_tag
    ) {
      file_path <- ""
      output_string = paste(output, collapse = "")

      part = strsplit(output_string, "<csv_file_path>")[[1]][2]
      file_path <- strsplit(part, "</csv_file_path>")[[1]][1]

      log_debug("file: {file_path}")
      if ( is.na(file_path) || is.null(file_path) || nchar(file_path) < 1 ) {
        return (NULL)
      }

      if (!file.exists(file_path))
        return (NULL)

      df <- read.csv(file_path)
      df
    },


    #' @description
    #' test method.
    #' This is a test function
    test = function() {
      self$path_to_file_or_dir = "JAXDP00006X"
      study_sources = self$get_study_sources()
      study_sources
    },

    #' @description
    #' get_version, get current version
    #'
    #' @return character, version
    get_version = function() {
      "0.0.1 build_2024_06_26"
    },

    #' @description
    #' finalize
    finalize = function() {
    },

    #' @description
    #' print
    print = function() {
      cat("JBQ: \n")
      cat("  path_to_file_or_dir: ", self$path_to_file_or_dir, "\n", sep = "")
      invisible(self)
    }
  ),
  lock_objects = FALSE,
  lock_class = TRUE
)




