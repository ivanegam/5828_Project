# Readme
## CU Boulder — CSCI 5828, Spring 2021

### Final project: Covid Tweets

#### Team information
Team Dysfunctional: Stephane Aroca-Ouellette, Derek Mease, Ivane Gamkrelidze, and Dalton Wiebold

#### Deliverables
* [User stories](https://trello.com/b/QtD0CL5f/csci-5828-project-team-dysfunction)
* [Wiki documentation](https://github.com/ivanegam/5828_Project/wiki/Project-overview)
* [Burndown charts](https://github.com/ivanegam/5828_Project/wiki/Iteration-planning)
* [Progress summary](https://github.com/ivanegam/5828_Project/wiki/Progress-summary)
* Prototype
    * Developement: https://protected-refuge-98620.herokuapp.com/
    * Production: https://shrouded-meadow-88761.herokuapp.com/
* [Project presentation](https://docs.google.com/presentation/d/1YHdtUbxjbzf_pvAHLn7JDnSwTFtGWrYbW0kEa4sKkAk/edit?usp=sharing)

#### Project rubric

1. Web application; basic form, reporting
    * Web application: https://shrouded-meadow-88761.herokuapp.com/

1. Data collection; batch worker
    * [`covid_daily_tweets.ex`](apps/covid_daily_tweets/lib/covid_daily_tweets.ex): lines 63–99
    * [`covid_cases.ex`](apps/covid_cases/lib/covid_cases.ex): lines 39–49
    * [`covid_vaccines.ex`](apps/covid_vaccines/lib/covid_vaccines.ex): lines 108–118

1. Data analyzer
    * [`data_analysis.ex`](apps/data_analysis/lib/data_analysis.ex)
    * [`covid_cases.ex`](apps/covid_cases/lib/covid_cases.ex): lines 9–22
    * [`covid_vaccines.ex`](apps/covid_vaccines/lib/covid_vaccines.ex): lines 78–90

1. Unit tests
    * [`data_analysis_test.exs`](apps/data_analysis/test/data_analysis_test.exs)
    * [`covid_daily_tweets_test.exs`](apps/covid_daily_tweets/test/covid_daily_tweets_test.exs): lines 43–124
    * [`data_tweet_test.exs`](apps/data/test/data_tweet_test.exs)
    * [`data_daily_count_test.exs`](apps/data/test/data_daily_count_test.exs): lines 7–102

1. Data persistence; any data store
   * Heroku Postgres (password-protected; illustrated [here](psql.png))

1. Rest collaboration; internal or API endpoint
    * [`covid_daily_tweets.ex`](apps/covid_daily_tweets/lib/covid_daily_tweets.ex): lines 63–99
    * [`covid_cases.ex`](apps/covid_cases/lib/covid_cases.ex): lines 39–49

1. Product environment
   * Heroku Pipelines: auto deploys to the staging app, then promoted to the production app (password-protected; illustrated [here](pipeline.png))

1. Integration tests
    * [`data_daily_count_test.exs`](apps/data/test/data_daily_count_test.exs): lines 104–172

1. Using mock objects or any test doubles
    * [`covid_vaccines_test.exs`](apps/covid_vaccines/test/covid_vaccines_test.exs)
    * [`covid_daily_tweets_test.exs`](apps/covid_daily_tweets/test/covid_daily_tweets_test.exs): lines 12–41
    * [`covid_cases_test.exs`](apps/covid_cases/test/covid_cases_test.exs)

1. Continuous integration
    * [GitHub Actions](https://github.com/ivanegam/5828_Project/actions)

1. Production monitoring instrumenting
    * [Phoenix LiveDashboard](https://shrouded-meadow-88761.herokuapp.com/dashboard/home) (password-protected; illustrated [here](livedashboard.png))

1. Acceptance tests
    * [`acceptance_test.exs`](apps/covid_tweets_web/test/covid_tweets_web/acceptance/acceptance_test.exs): lines 18–123 (instructions for running tests on the [wiki](https://github.com/ivanegam/5828_Project/wiki/Testing#acceptance-tests))

1. Event collaboration messaging
    * [`page_live.ex`](apps/covid_tweets_web/lib/covid_tweets_web/live/page_live.ex): lines 13–63

1. Continuous delivery
    * Heroku: automatic deploys enabled after CI passing (password-protected; illustrated [here](autodeploys.png))
