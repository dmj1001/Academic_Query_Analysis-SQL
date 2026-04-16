# Academic Data Modeling & Relational Query Analysis

## Overview
This project involves a comprehensive set of SQL queries designed to manage and analyze an educational database. It focuses on extracting meaningful insights from student records, course details, and enrollment data, such as tracking academic performance through GPA calculations and ranking systems.

## Database Schema
The project operates on a database schema containing several key tables:
* **Students:** Contains personal details including student ID, name, email, phone, and enrollment date.
* **Courses:** Stores information on course names, instructors, departments, and credit values.
* **Enrollments:** Records the relationship between students and courses, including grades and enrollment status.

## Key SQL Implementation Details
* **Relational Joins:** Utilizes `JOIN` operations to combine student, course, and enrollment tables to generate detailed reports like student transcripts with grades.
* **Academic Performance Analysis:** Employs `CASE` statements to convert letter grades (A, B+, etc.) into numerical values for calculating a **ROUNDED AVG GPA** per course.
* **Window Functions:**
    * **RANK():** Used to rank courses by popularity (enrollment count) and students by their course load.
    * **ROW_NUMBER():** Applied with `PARTITION BY` to assign a sequence number to enrollments for each specific student.
* **Advanced Filtering:**
    * **Subqueries:** Implemented to find courses with enrollment counts higher than the overall average.
    * **Common Table Expressions (CTEs):** Used to identify high-volume students who have enrolled in more than three courses.
* **Data Organization:** Extensive use of `GROUP BY` and `ORDER BY` for department-level reporting and chronological data retrieval.

## Analytical Insights
* **Course Popularity:** Identification of top-tier courses like **Database Systems** and **Operating Systems** based on student counts.
* **Grade Distribution:** Tracking of enrollment statuses to manage academic progress across the batch.
* **GPA Benchmarking:** Comparison of individual student performance against course averages using correlated subqueries.

## Technical Stack
* **Database Engine:** MySQL / MariaDB.
* **Scripting:** Advanced SQL (joins, aggregations, window functions, and CTEs).
