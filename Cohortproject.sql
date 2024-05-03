WITH SubscriptionsWithWeeks AS (
  SELECT
    user_pseudo_id AS ID,
    DATE_TRUNC(subscription_start, week) AS Startweeknumber,
    COUNT(user_pseudo_id) OVER (PARTITION BY DATE_TRUNC(subscription_start, week) ORDER BY subscription_start) AS StartQty,
    DATE_TRUNC(subscription_end, week) AS Endweeknumber
  FROM
    `turing_data_analytics.subscriptions`
  WHERE
    subscription_start <= '2021-02-07'
) --Divide customers according theyr start date to cohorts by weeks.

SELECT
  Startweeknumber,--Weekly cohorts
  COUNT(DISTINCT ID) AS CustomersStarted,--Count of customers that started certain week
  ROUND(((COUNT(DISTINCT ID) - COUNT(DISTINCT CASE WHEN Startweeknumber = Endweeknumber THEN ID END))/COUNT(DISTINCT ID)*100),2) AS SubscriptionsAfterWeek0, -- First calculated how many customers has churned in week when they started, then that number was subtracted from the original quantity and divided from quantity at the begining and calculated retention % and for following week same principe just previous week results added to churn customers quantity
 ROUND (((((COUNT(DISTINCT ID) - COUNT(DISTINCT CASE WHEN Startweeknumber = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 1 WEEK) = Endweeknumber THEN ID END))/COUNT(DISTINCT ID))*100),2) AS SubscriptionsAfterWeek1,
ROUND((((((COUNT(DISTINCT ID) - COUNT(DISTINCT CASE WHEN Startweeknumber = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 1 WEEK) = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 2 WEEK) = Endweeknumber THEN ID END))/COUNT(DISTINCT ID))*100),2) AS SubscriptionsAfterWeek2,
ROUND(((((((COUNT(DISTINCT ID) - COUNT(DISTINCT CASE WHEN Startweeknumber = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 1 WEEK) = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 2 WEEK) = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 3 WEEK) = Endweeknumber THEN ID END))/COUNT(DISTINCT ID))*100),2) AS SubscriptionsAfterWeek3,
ROUND((((((((COUNT(DISTINCT ID) - COUNT(DISTINCT CASE WHEN Startweeknumber = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 1 WEEK) = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 2 WEEK) = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 3 WEEK) = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 4 WEEK) = Endweeknumber THEN ID END))/COUNT(DISTINCT ID))*100),2) AS SubscriptionsAfterWeek4,
ROUND(((((((((COUNT(DISTINCT ID) - COUNT(DISTINCT CASE WHEN Startweeknumber = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 1 WEEK) = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 2 WEEK) = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 3 WEEK) = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 4 WEEK) = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 5 WEEK) = Endweeknumber THEN ID END))/COUNT(DISTINCT ID))*100),2) AS SubscriptionsAfterWeek5,
ROUND(((((((((COUNT(DISTINCT ID) - COUNT(DISTINCT CASE WHEN Startweeknumber = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 1 WEEK) = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 2 WEEK) = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 3 WEEK) = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 4 WEEK) = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 5 WEEK) = Endweeknumber THEN ID END))-
  COUNT(DISTINCT CASE WHEN DATE_ADD(Startweeknumber, INTERVAL 6 WEEK) = Endweeknumber THEN ID END))/COUNT(DISTINCT ID))*100,2) AS SubscriptionsAfterWeek6
FROM
  SubscriptionsWithWeeks
GROUP BY
  Startweeknumber
ORDER BY
  Startweeknumber;
