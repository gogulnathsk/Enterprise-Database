Introduction

The project involves creating a comprehensive SQL database system for Galaxy Studios, a film production company focused on pre-production and production activities.
Company Overview

Galaxy Studios specializes in high-quality film production across genres like drama, action, and sci-fi. Operations include script refinement, casting, filming coordination, and daily schedule management.
Data Management Requirements

Talent Management: Store detailed information about actors, crew, and directors.
Production Tracking: Manage schedules, budgets, and filming logistics.
Awards and Feedback: Track recognitions and collect audience reviews.
Operational Efficiency: Enable seamless collaboration and optimize resource utilization.

Database Design
The system uses an Entity-Relationship (ER) model, normalized to Third Normal Form (3NF) to minimize redundancy and maintain data integrity.
Core entities include Movies, Actors, Directors, Producers, Crew, Awards, and Reviews.

SQL Implementation
Tables created for movies, actors, directors, crew, awards, and reviews.
Constraints like primary keys and foreign keys ensure relational integrity.
Example SQL scripts include table creation, relationships establishment, and sample data insertion.

Stored Procedures and Triggers
Procedures automate tasks like updating movie revenues, inserting new records, and retrieving top-rated movies.
Triggers enforce business rules such as preventing duplicate awards or negative revenues.

Complex Queries
Includes queries like finding top 5 revenue-generating movies with female antagonists or retrieving award-winning movies.
Optimized queries use indexing to improve performance.

Indexing and Optimization
Key columns like Genre, Revenue, and Award Date are indexed to speed up queries.
Query optimization removes redundant subqueries and ensures efficient use of indexes.

Data Security
User roles defined (e.g., Admin, Reviewer) with specific permissions to ensure secure data access and prevent unauthorized modifications.

Backup and Recovery
Full backups weekly, differential backups daily, and transaction logs hourly.
Backup storage includes on-site encrypted devices and off-site cloud solutions.

Validation and Testing
Backup and restore tests ensure data integrity.
Automated alerts monitor backup status.

Deliverables
Fully implemented SQL database with all scripts and sample data.
Documentation of ER diagrams, database schema, queries, and procedures.
