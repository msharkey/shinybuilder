
df <- shinyloadtest::load_runs(
  "50workersCache" = "./test-logs-2019-07-22T11_36_05.908Z" ,
  "50workers" = "./test-logs-2019-07-22T03_21_19.997Z")

shinyloadtest::shinyloadtest_report(df, "run4.html")


df <- shinyloadtest::load_runs("50workers" = "./test-logs-2019-07-22T03_21_19.997Z")

shinyloadtest::shinyloadtest_report(df, "run1.html")

