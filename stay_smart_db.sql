-- ==========================================
-- STAY SMART DATABASE
-- Student Accommodation Discovery System
-- ==========================================


-- ==========================================
-- 1. USERS TABLE
-- ==========================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    role ENUM('student','owner','admin') DEFAULT 'student',
    profile_image VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;


-- ==========================================
-- 2. PROPERTIES TABLE
-- ==========================================
CREATE TABLE properties (
    property_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    city VARCHAR(100),
    area VARCHAR(100),
    address TEXT,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(user_id)
    ON DELETE CASCADE
) ENGINE=InnoDB;


-- ==========================================
-- 3. ROOMS TABLE
-- ==========================================
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT NOT NULL,
    room_type ENUM('single','shared') NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    available_rooms INT DEFAULT 0,
    image VARCHAR(255),
    FOREIGN KEY (property_id) REFERENCES properties(property_id)
    ON DELETE CASCADE
) ENGINE=InnoDB;


-- ==========================================
-- 4. AMENITIES TABLE
-- ==========================================
CREATE TABLE amenities (
    amenity_id INT AUTO_INCREMENT PRIMARY KEY,
    amenity_name VARCHAR(100) UNIQUE
) ENGINE=InnoDB;


-- ==========================================
-- 5. PROPERTY_AMENITIES TABLE
-- ==========================================
CREATE TABLE property_amenities (
    property_id INT,
    amenity_id INT,
    PRIMARY KEY (property_id, amenity_id),
    FOREIGN KEY (property_id) REFERENCES properties(property_id)
    ON DELETE CASCADE,
    FOREIGN KEY (amenity_id) REFERENCES amenities(amenity_id)
    ON DELETE CASCADE
) ENGINE=InnoDB;


-- ==========================================
-- 6. BOOKINGS TABLE
-- ==========================================
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    status ENUM('pending','approved','rejected','completed') DEFAULT 'pending',
    visit_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
    ON DELETE CASCADE
) ENGINE=InnoDB;


-- ==========================================
-- 7. REVIEWS TABLE
-- ==========================================
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE,
    FOREIGN KEY (property_id) REFERENCES properties(property_id)
    ON DELETE CASCADE
) ENGINE=InnoDB;


-- ==========================================
-- 8. NOTIFICATIONS TABLE
-- ==========================================
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE
) ENGINE=InnoDB;


-- ==========================================
-- 9. AI CHAT LOGS TABLE
-- ==========================================
CREATE TABLE ai_chat_logs (
    chat_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    user_query TEXT,
    ai_response TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE
) ENGINE=InnoDB;


-- ==========================================
-- INDEXES FOR SEARCH OPTIMIZATION
-- ==========================================
CREATE INDEX idx_city ON properties(city);
CREATE INDEX idx_price ON rooms(price);
CREATE INDEX idx_room_type ON rooms(room_type);


-- ==========================================
-- SAMPLE DATA
-- ==========================================

-- Insert Admin
INSERT INTO users (full_name, email, password, role)
VALUES ('Admin User', 'admin@staysmart.com', '$2y$10$examplehash', 'admin');

-- Insert Sample Owner
INSERT INTO users (full_name, email, password, role)
VALUES ('PG Owner', 'owner@staysmart.com', '$2y$10$examplehash', 'owner');

-- Insert Sample Property
INSERT INTO properties (owner_id, title, description, city, area, address)
VALUES (2, 'Comfort PG Pune', 'Clean and affordable PG', 'Pune', 'Shivaji Nagar', 'Near FC Road');

-- Insert Sample Room
INSERT INTO rooms (property_id, room_type, price, available_rooms)
VALUES (1, 'single', 4500, 3);
