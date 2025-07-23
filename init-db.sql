-- Initialization script for PostgreSQL database
-- This script creates additional databases for testing and production

-- Create test database
CREATE DATABASE api_ia_invoices_test;

-- Create production database (optional for local development)
-- CREATE DATABASE api_ia_invoices_production;

-- Grant privileges to postgres user
GRANT ALL PRIVILEGES ON DATABASE api_ia_invoices_development TO postgres;
GRANT ALL PRIVILEGES ON DATABASE api_ia_invoices_test TO postgres;
-- GRANT ALL PRIVILEGES ON DATABASE api_ia_invoices_production TO postgres;

-- Create extensions if needed
\c api_ia_invoices_development;
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- CREATE EXTENSION IF NOT EXISTS "pg_trgm";

\c api_ia_invoices_test;
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- CREATE EXTENSION IF NOT EXISTS "pg_trgm";