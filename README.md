# Namma_Yatri_SQL.io

# 🛺 Namma Yatri Data Analysis using SQL

This project presents an exploratory SQL analysis of **Namma Yatri**, a rapidly growing, open-source ride-hailing app in Bengaluru. Using realistic trip and ride-detail datasets, this analysis extracts key insights into urban mobility patterns, driver earnings, user behavior, and platform performance metrics.

---

## 📌 About Namma Yatri

[Namma Yatri](https://nammayatri.in/) is a commission-free, driver-first auto and cab booking app developed by **Juspay** in collaboration with **Beckn Foundation** and backed by **ONDC (Open Network for Digital Commerce)**. It promotes fair pricing and direct driver-rider connections, making it a strong ethical alternative to traditional ride-hailing platforms.

---

## 🧠 Project Objectives

- Analyze trip volumes, fare trends, and ride completion rates.
- Evaluate user behavior and conversion metrics (search → booking).
- Identify top-performing drivers and most popular routes.
- Uncover cancellation patterns and fare distribution across locations and time.
- Determine the most used and highest grossing payment methods.

---

## 🗂️ Dataset & Schema

The project uses synthetic data modeled after Namma Yatri's real-world structure:

- `trips`: Contains trip-level info like fare, driver, customer, distance, and duration.
- `trips_details1/2/3`: Contains ride funnel details (searches, estimates, bookings).
- `trips_details4`: Combined unified table from the above.
- `payment`, `loc`, `duration`: Lookup tables for interpretation.

---

## 🛠️ Tools & Skills

- **SQL (MySQL)**
- Joins, aggregations, window functions, CTEs
- Analytical KPIs and conversion rate calculations
- Data modeling and union operations

---

## 📊 Key Insights Extracted

- ✅ Total Trips, Completed Rides, Drivers
- 💰 Total Earnings, Average Fare & Distance
- 🔁 Funnel Metrics: Search → Estimate → Quote → Booking
- 🚫 Booking Cancellation Rates
- 🧑‍✈️ Top 5 Drivers by Earnings & Max Fare
- 📍 Top Locations by Trips, Cancellations, Revenue
- 🕒 Peak Durations for Travel
- 💳 Most Used & Highest Revenue Payment Method

---

## 📌 Sample Queries

```sql
-- Total earnings
SELECT SUM(fare) AS total_earnings FROM trips;

-- Booking cancellation rate
SELECT 
  ROUND(
    (SUM(searches_got_quotes) - SUM(end_ride)) * 100 / NULLIF(SUM(searches_got_quotes), 0), 
    2
  ) AS "booking cancellation rate"
FROM trips_details4;

📈 Outcomes
This project showcases how SQL can be effectively used for real-world data analysis in the mobility sector, providing deep insights into operational performance, user behavior, and strategic decision-making.

