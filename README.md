# Readme
## CU Boulder — CSCI 5828, Spring 2021

### Final project: Covid Tweets

Final project for CSCI 5828. See [project overview](https://github.com/ivanegam/5828_Project/wiki/Project-overview).

Deployed to:
- Developement: https://protected-refuge-98620.herokuapp.com/
- Production: https://shrouded-meadow-88761.herokuapp.com/

#### Team information
Stephane Aroca-Ouellette, Derek Mease, Ivane Gamkrelidze, and Dalton Wiebold

#### Project rubric

1. Web application; basic form, reporting
    * Web application: https://shrouded-meadow-88761.herokuapp.com/

1. Data collection; batch worker
    * [covid_daily_tweets.ex](apps/covid_daily_tweets/lib/covid_daily_tweets.ex)
    * [covid_cases.ex](apps/covid_cases/lib/covid_cases.ex)
    * [covid_vaccines.ex](apps/covid_vaccines/lib/covid_vaccines.ex)

1. Data analyzer
    * [data_analysis.ex](apps/data_analysis/lib/data_analysis.ex)
    * [covid_cases.ex](apps/covid_cases/lib/covid_cases.ex)
    * [covid_vaccines.ex](apps/covid_vaccines/lib/covid_vaccines.ex)

1. Unit tests
    * [data_analysis_test.exs](apps/data_analysis/test/data_analysis_test.exs)
    * [covid_daily_tweets_test.exs](apps/covid_daily_tweets/test/covid_daily_tweets_test.exs)
    * [data_tweet_test.exs](apps/data/test/data_tweet_test.exs)
    * [data_daily_count_test.exs](apps/data/test/data_daily_count_test.exs)

1. Data persistence; any data store
   * Heroku Postgres

1. Rest collaboration; internal or API endpoint
    * [covid_daily_tweets.ex](apps/covid_daily_tweets/lib/covid_daily_tweets.ex)
    * [covid_cases.ex](apps/covid_cases/lib/covid_cases.ex)

1. Product environment
   * Heroku Pipelines: auto deploys to the staging app, then promoted to the production app

1. Integration tests
    * [data_daily_count_test.exs](apps/data/test/data_daily_count_test.exs)

1. Using mock objects or any test doubles
    * [covid_vaccines_test.exs](apps/covid_vaccines/test/covid_vaccines_test.exs)
    * [covid_daily_tweets_test.exs](apps/covid_daily_tweets/test/covid_daily_tweets_test.exs)
    * [covid_cases_test.exs](apps/covid_cases/test/covid_cases_test.exs)

1. Continuous integration
    * [GitHub Actions](https://github.com/ivanegam/5828_Project/actions)

1. Production monitoring instrumenting
    * [Phoenix LiveDashboard](https://shrouded-meadow-88761.herokuapp.com/dashboard/home)

1. Acceptance tests
    * [acceptance_test.exs](apps/covid_tweets_web/test/covid_tweets_web/acceptance/acceptance_test.exs)

1. Event collaboration messaging
    * [page_live.ex](apps/covid_tweets_web/lib/covid_tweets_web/live/page_live.ex)

1. Continuous delivery
    * Heroku: automatic deploys enabled after CI passing
