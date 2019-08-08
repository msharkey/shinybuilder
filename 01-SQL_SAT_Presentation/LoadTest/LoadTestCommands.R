


library(shinyloadtest)

record_session('http://127.0.0.1:5516/')

java -jar shinycannon-1.0.0-c9c02cb.jar recording.log http://127.0.0.1:5516/ --workers 50 --loaded-duration-minutes 2



df <- load_runs("50_workersCached2" = "C:/Users/mshar/OneDrive/Old/Documents/test-logs-2019-08-08T03_23_50.468Z")

shinyloadtest_report(df, "run4.html")