    CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    account_type VARCHAR(20) NOT NULL,
    updated_at TIMESTAMP DEFAULT timezone('UTC', CURRENT_TIMESTAMP),
    created_at TIMESTAMP DEFAULT timezone('UTC', CURRENT_TIMESTAMP)
    );

    INSERT INTO users (username, account_type) VALUES
    ('user1', 'Bronze'),
    ('user2', 'Silver'),
    ('user3', 'Gold');
    ALTER SYSTEM SET wal_level = 'logical';




