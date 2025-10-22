-- Vidyalankar Library Management System - Database Schema
-- Multi-Tenant Architecture for VSIT, VIT, and VP

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Trust Management
CREATE TABLE trusts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    config JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Colleges
CREATE TABLE colleges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    trust_id UUID REFERENCES trusts(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL, -- VSIT, VIT, VP
    type VARCHAR(100) NOT NULL, -- Engineering, Polytechnic, etc.
    address JSONB DEFAULT '{}',
    contact_info JSONB DEFAULT '{}',
    config JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Libraries
CREATE TABLE libraries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    college_id UUID REFERENCES colleges(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(50) NOT NULL,
    capacity INTEGER DEFAULT 0,
    current_occupancy INTEGER DEFAULT 0,
    operating_hours JSONB DEFAULT '{}',
    config JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(college_id, code)
);

-- User Types Enum
CREATE TYPE user_type_enum AS ENUM ('student', 'staff', 'faculty', 'librarian', 'college_admin', 'trust_admin');

-- Users (Students, Staff, Faculty)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    college_id UUID REFERENCES colleges(id) ON DELETE CASCADE,
    user_type user_type_enum NOT NULL,
    student_id VARCHAR(50), -- College-specific student ID
    employee_id VARCHAR(50), -- For staff/faculty
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20),
    fcm_token TEXT,
    profile_image_url TEXT,
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(college_id, student_id),
    UNIQUE(college_id, employee_id)
);

-- Library Logs
CREATE TABLE library_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    library_id UUID REFERENCES libraries(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    entry_time TIMESTAMP NOT NULL,
    exit_time TIMESTAMP,
    reason TEXT,
    device_id VARCHAR(100),
    status VARCHAR(20) DEFAULT 'IN', -- IN, OUT
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Book Categories
CREATE TABLE book_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Books
CREATE TABLE books (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    library_id UUID REFERENCES libraries(id) ON DELETE CASCADE,
    category_id UUID REFERENCES book_categories(id),
    isbn VARCHAR(20),
    title VARCHAR(500) NOT NULL,
    author VARCHAR(255),
    publisher VARCHAR(255),
    edition VARCHAR(50),
    publication_year INTEGER,
    total_copies INTEGER DEFAULT 1,
    available_copies INTEGER DEFAULT 1,
    shelf_location VARCHAR(100),
    description TEXT,
    cover_image_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Book Borrowing
CREATE TABLE book_borrowings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    library_id UUID REFERENCES libraries(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    borrow_date TIMESTAMP NOT NULL,
    due_date TIMESTAMP NOT NULL,
    return_date TIMESTAMP,
    fine_amount DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'BORROWED', -- BORROWED, RETURNED, OVERDUE, LOST
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Notifications
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL, -- info, warning, error, success
    is_read BOOLEAN DEFAULT false,
    data JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW()
);

-- System Settings
CREATE TABLE system_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    college_id UUID REFERENCES colleges(id) ON DELETE CASCADE,
    setting_key VARCHAR(100) NOT NULL,
    setting_value TEXT,
    setting_type VARCHAR(50) DEFAULT 'string', -- string, number, boolean, json
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(college_id, setting_key)
);

-- Audit Logs
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    college_id UUID REFERENCES colleges(id) ON DELETE CASCADE,
    action VARCHAR(100) NOT NULL,
    resource VARCHAR(100) NOT NULL,
    resource_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for Performance
CREATE INDEX idx_users_college_id ON users(college_id);
CREATE INDEX idx_users_student_id ON users(student_id);
CREATE INDEX idx_users_employee_id ON users(employee_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_user_type ON users(user_type);

CREATE INDEX idx_library_logs_library_id ON library_logs(library_id);
CREATE INDEX idx_library_logs_user_id ON library_logs(user_id);
CREATE INDEX idx_library_logs_entry_time ON library_logs(entry_time);
CREATE INDEX idx_library_logs_status ON library_logs(status);

CREATE INDEX idx_books_library_id ON books(library_id);
CREATE INDEX idx_books_category_id ON books(category_id);
CREATE INDEX idx_books_isbn ON books(isbn);
CREATE INDEX idx_books_title ON books(title);

CREATE INDEX idx_book_borrowings_user_id ON book_borrowings(user_id);
CREATE INDEX idx_book_borrowings_book_id ON book_borrowings(book_id);
CREATE INDEX idx_book_borrowings_due_date ON book_borrowings(due_date);
CREATE INDEX idx_book_borrowings_status ON book_borrowings(status);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);

CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_college_id ON audit_logs(college_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);

-- Functions for automatic timestamp updates
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_trusts_updated_at BEFORE UPDATE ON trusts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_colleges_updated_at BEFORE UPDATE ON colleges FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_libraries_updated_at BEFORE UPDATE ON libraries FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_library_logs_updated_at BEFORE UPDATE ON library_logs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_books_updated_at BEFORE UPDATE ON books FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_book_borrowings_updated_at BEFORE UPDATE ON book_borrowings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_system_settings_updated_at BEFORE UPDATE ON system_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to update library occupancy
CREATE OR REPLACE FUNCTION update_library_occupancy()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.status = 'IN' THEN
            UPDATE libraries 
            SET current_occupancy = current_occupancy + 1 
            WHERE id = NEW.library_id;
        END IF;
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.status = 'IN' AND NEW.status = 'OUT' THEN
            UPDATE libraries 
            SET current_occupancy = current_occupancy - 1 
            WHERE id = NEW.library_id;
        ELSIF OLD.status = 'OUT' AND NEW.status = 'IN' THEN
            UPDATE libraries 
            SET current_occupancy = current_occupancy + 1 
            WHERE id = NEW.library_id;
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        IF OLD.status = 'IN' THEN
            UPDATE libraries 
            SET current_occupancy = current_occupancy - 1 
            WHERE id = OLD.library_id;
        END IF;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ language 'plpgsql';

-- Trigger for library occupancy
CREATE TRIGGER update_library_occupancy_trigger
    AFTER INSERT OR UPDATE OR DELETE ON library_logs
    FOR EACH ROW EXECUTE FUNCTION update_library_occupancy();

-- Function to update book availability
CREATE OR REPLACE FUNCTION update_book_availability()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.status = 'BORROWED' THEN
            UPDATE books 
            SET available_copies = available_copies - 1 
            WHERE id = NEW.book_id;
        END IF;
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.status = 'BORROWED' AND NEW.status = 'RETURNED' THEN
            UPDATE books 
            SET available_copies = available_copies + 1 
            WHERE id = NEW.book_id;
        ELSIF OLD.status = 'RETURNED' AND NEW.status = 'BORROWED' THEN
            UPDATE books 
            SET available_copies = available_copies - 1 
            WHERE id = NEW.book_id;
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        IF OLD.status = 'BORROWED' THEN
            UPDATE books 
            SET available_copies = available_copies + 1 
            WHERE id = OLD.book_id;
        END IF;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ language 'plpgsql';

-- Trigger for book availability
CREATE TRIGGER update_book_availability_trigger
    AFTER INSERT OR UPDATE OR DELETE ON book_borrowings
    FOR EACH ROW EXECUTE FUNCTION update_book_availability();
