-- Vidyalankar Library Management System - Sample Data
-- Insert initial data for VSIT, VIT, and VP

-- Insert Trust
INSERT INTO trusts (id, name, code, description) VALUES 
('550e8400-e29b-41d4-a716-446655440000', 'Vidyalankar Dhyanpeeth Trust', 'VDT', 'Educational trust managing multiple colleges');

-- Insert Colleges
INSERT INTO colleges (id, trust_id, name, code, type, address, contact_info) VALUES 
('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', 'Vidyalankar School of Information Technology', 'VSIT', 'Engineering', 
 '{"street": "Vidyalankar Campus", "city": "Mumbai", "state": "Maharashtra", "pincode": "400001"}',
 '{"phone": "+91-22-12345678", "email": "info@vsit.edu.in", "website": "www.vsit.edu.in"}'),

('550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440000', 'Vidyalankar Institute of Technology', 'VIT', 'Engineering', 
 '{"street": "Vidyalankar Campus", "city": "Mumbai", "state": "Maharashtra", "pincode": "400001"}',
 '{"phone": "+91-22-12345679", "email": "info@vit.edu.in", "website": "www.vit.edu.in"}'),

('550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440000', 'Vidyalankar Polytechnic', 'VP', 'Polytechnic', 
 '{"street": "Vidyalankar Campus", "city": "Mumbai", "state": "Maharashtra", "pincode": "400001"}',
 '{"phone": "+91-22-12345680", "email": "info@vp.edu.in", "website": "www.vp.edu.in"}');

-- Insert Libraries
INSERT INTO libraries (id, college_id, name, code, capacity, operating_hours) VALUES 
('550e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440001', 'VSIT Central Library', 'VSIT_LIB', 200,
 '{"monday": {"open": "08:00", "close": "20:00"}, "tuesday": {"open": "08:00", "close": "20:00"}, "wednesday": {"open": "08:00", "close": "20:00"}, "thursday": {"open": "08:00", "close": "20:00"}, "friday": {"open": "08:00", "close": "20:00"}, "saturday": {"open": "09:00", "close": "17:00"}, "sunday": {"open": "10:00", "close": "16:00"}}'),

('550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440002', 'VIT Central Library', 'VIT_LIB', 250,
 '{"monday": {"open": "08:00", "close": "20:00"}, "tuesday": {"open": "08:00", "close": "20:00"}, "wednesday": {"open": "08:00", "close": "20:00"}, "thursday": {"open": "08:00", "close": "20:00"}, "friday": {"open": "08:00", "close": "20:00"}, "saturday": {"open": "09:00", "close": "17:00"}, "sunday": {"open": "10:00", "close": "16:00"}}'),

('550e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440003', 'VP Central Library', 'VP_LIB', 150,
 '{"monday": {"open": "08:00", "close": "18:00"}, "tuesday": {"open": "08:00", "close": "18:00"}, "wednesday": {"open": "08:00", "close": "18:00"}, "thursday": {"open": "08:00", "close": "18:00"}, "friday": {"open": "08:00", "close": "18:00"}, "saturday": {"open": "09:00", "close": "15:00"}, "sunday": "closed"}');

-- Insert Book Categories
INSERT INTO book_categories (id, name, description) VALUES 
('550e8400-e29b-41d4-a716-446655440020', 'Computer Science', 'Books related to computer science and programming'),
('550e8400-e29b-41d4-a716-446655440021', 'Information Technology', 'IT and software engineering books'),
('550e8400-e29b-41d4-a716-446655440022', 'Electronics', 'Electronics and communication engineering'),
('550e8400-e29b-41d4-a716-446655440023', 'Mechanical Engineering', 'Mechanical engineering textbooks'),
('550e8400-e29b-41d4-a716-446655440024', 'Civil Engineering', 'Civil engineering and construction'),
('550e8400-e29b-41d4-a716-446655440025', 'Mathematics', 'Mathematics and statistics'),
('550e8400-e29b-41d4-a716-446655440026', 'Physics', 'Physics and applied sciences'),
('550e8400-e29b-41d4-a716-446655440027', 'General', 'General knowledge and reference books');

-- Insert Sample Users (Students)
INSERT INTO users (id, college_id, user_type, student_id, first_name, last_name, email, phone) VALUES 
-- VSIT Students
('550e8400-e29b-41d4-a716-446655440030', '550e8400-e29b-41d4-a716-446655440001', 'student', 'VSIT2024001', 'Raj', 'Patel', 'raj.patel@vsit.edu.in', '+91-9876543210'),
('550e8400-e29b-41d4-a716-446655440031', '550e8400-e29b-41d4-a716-446655440001', 'student', 'VSIT2024002', 'Priya', 'Sharma', 'priya.sharma@vsit.edu.in', '+91-9876543211'),
('550e8400-e29b-41d4-a716-446655440032', '550e8400-e29b-41d4-a716-446655440001', 'student', 'VSIT2024003', 'Amit', 'Kumar', 'amit.kumar@vsit.edu.in', '+91-9876543212'),

-- VIT Students
('550e8400-e29b-41d4-a716-446655440033', '550e8400-e29b-41d4-a716-446655440002', 'student', 'VIT2024001', 'Sneha', 'Singh', 'sneha.singh@vit.edu.in', '+91-9876543213'),
('550e8400-e29b-41d4-a716-446655440034', '550e8400-e29b-41d4-a716-446655440002', 'student', 'VIT2024002', 'Vikram', 'Joshi', 'vikram.joshi@vit.edu.in', '+91-9876543214'),
('550e8400-e29b-41d4-a716-446655440035', '550e8400-e29b-41d4-a716-446655440002', 'student', 'VIT2024003', 'Anita', 'Gupta', 'anita.gupta@vit.edu.in', '+91-9876543215'),

-- VP Students
('550e8400-e29b-41d4-a716-446655440036', '550e8400-e29b-41d4-a716-446655440003', 'student', 'VP2024001', 'Rohit', 'Verma', 'rohit.verma@vp.edu.in', '+91-9876543216'),
('550e8400-e29b-41d4-a716-446655440037', '550e8400-e29b-41d4-a716-446655440003', 'student', 'VP2024002', 'Kavya', 'Reddy', 'kavya.reddy@vp.edu.in', '+91-9876543217'),
('550e8400-e29b-41d4-a716-446655440038', '550e8400-e29b-41d4-a716-446655440003', 'student', 'VP2024003', 'Arjun', 'Nair', 'arjun.nair@vp.edu.in', '+91-9876543218');

-- Insert Faculty/Staff
INSERT INTO users (id, college_id, user_type, employee_id, first_name, last_name, email, phone) VALUES 
-- VSIT Faculty
('550e8400-e29b-41d4-a716-446655440040', '550e8400-e29b-41d4-a716-446655440001', 'faculty', 'VSIT_F001', 'Dr. Sunil', 'Mehta', 'sunil.mehta@vsit.edu.in', '+91-9876543220'),
('550e8400-e29b-41d4-a716-446655440041', '550e8400-e29b-41d4-a716-446655440001', 'librarian', 'VSIT_L001', 'Mrs. Rekha', 'Desai', 'rekha.desai@vsit.edu.in', '+91-9876543221'),

-- VIT Faculty
('550e8400-e29b-41d4-a716-446655440042', '550e8400-e29b-41d4-a716-446655440002', 'faculty', 'VIT_F001', 'Prof. Ravi', 'Iyer', 'ravi.iyer@vit.edu.in', '+91-9876543222'),
('550e8400-e29b-41d4-a716-446655440043', '550e8400-e29b-41d4-a716-446655440002', 'librarian', 'VIT_L001', 'Mr. Suresh', 'Pandey', 'suresh.pandey@vit.edu.in', '+91-9876543223'),

-- VP Faculty
('550e8400-e29b-41d4-a716-446655440044', '550e8400-e29b-41d4-a716-446655440003', 'faculty', 'VP_F001', 'Dr. Meera', 'Krishnan', 'meera.krishnan@vp.edu.in', '+91-9876543224'),
('550e8400-e29b-41d4-a716-446655440045', '550e8400-e29b-41d4-a716-446655440003', 'librarian', 'VP_L001', 'Mrs. Lakshmi', 'Rao', 'lakshmi.rao@vp.edu.in', '+91-9876543225'),

-- Trust Admin
('550e8400-e29b-41d4-a716-446655440046', '550e8400-e29b-41d4-a716-446655440000', 'trust_admin', 'VDT_A001', 'Mr. Rajesh', 'Agarwal', 'rajesh.agarwal@vidyalankar.edu.in', '+91-9876543226');

-- Insert Sample Books
INSERT INTO books (id, library_id, category_id, isbn, title, author, publisher, edition, publication_year, total_copies, available_copies, shelf_location) VALUES 
-- VSIT Library Books
('550e8400-e29b-41d4-a716-446655440050', '550e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440020', '978-0134685991', 'Clean Code', 'Robert C. Martin', 'Prentice Hall', '1st', 2008, 5, 5, 'CS-001'),
('550e8400-e29b-41d4-a716-446655440051', '550e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440020', '978-0132350884', 'Clean Architecture', 'Robert C. Martin', 'Prentice Hall', '1st', 2017, 3, 3, 'CS-002'),
('550e8400-e29b-41d4-a716-446655440052', '550e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440021', '978-0134685991', 'Design Patterns', 'Gang of Four', 'Addison-Wesley', '1st', 1994, 4, 4, 'IT-001'),

-- VIT Library Books
('550e8400-e29b-41d4-a716-446655440053', '550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440022', '978-0134685991', 'Electronics Fundamentals', 'Thomas L. Floyd', 'Pearson', '11th', 2017, 6, 6, 'ECE-001'),
('550e8400-e29b-41d4-a716-446655440054', '550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440023', '978-0134685991', 'Mechanical Engineering', 'R. K. Rajput', 'Laxmi Publications', '8th', 2016, 5, 5, 'ME-001'),

-- VP Library Books
('550e8400-e29b-41d4-a716-446655440055', '550e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440024', '978-0134685991', 'Civil Engineering Basics', 'S. K. Duggal', 'McGraw Hill', '3rd', 2018, 4, 4, 'CE-001'),
('550e8400-e29b-41d4-a716-446655440056', '550e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440025', '978-0134685991', 'Engineering Mathematics', 'B. S. Grewal', 'Khanna Publishers', '44th', 2019, 8, 8, 'MATH-001');

-- Insert System Settings
INSERT INTO system_settings (college_id, setting_key, setting_value, setting_type, description) VALUES 
-- VSIT Settings
('550e8400-e29b-41d4-a716-446655440001', 'max_books_per_student', '5', 'number', 'Maximum books a student can borrow'),
('550e8400-e29b-41d4-a716-446655440001', 'borrowing_duration_days', '14', 'number', 'Default borrowing duration in days'),
('550e8400-e29b-41d4-a716-446655440001', 'fine_per_day', '5', 'number', 'Fine amount per day for overdue books'),
('550e8400-e29b-41d4-a716-446655440001', 'library_name', 'VSIT Central Library', 'string', 'Display name for the library'),

-- VIT Settings
('550e8400-e29b-41d4-a716-446655440002', 'max_books_per_student', '6', 'number', 'Maximum books a student can borrow'),
('550e8400-e29b-41d4-a716-446655440002', 'borrowing_duration_days', '15', 'number', 'Default borrowing duration in days'),
('550e8400-e29b-41d4-a716-446655440002', 'fine_per_day', '5', 'number', 'Fine amount per day for overdue books'),
('550e8400-e29b-41d4-a716-446655440002', 'library_name', 'VIT Central Library', 'string', 'Display name for the library'),

-- VP Settings
('550e8400-e29b-41d4-a716-446655440003', 'max_books_per_student', '4', 'number', 'Maximum books a student can borrow'),
('550e8400-e29b-41d4-a716-446655440003', 'borrowing_duration_days', '10', 'number', 'Default borrowing duration in days'),
('550e8400-e29b-41d4-a716-446655440003', 'fine_per_day', '3', 'number', 'Fine amount per day for overdue books'),
('550e8400-e29b-41d4-a716-446655440003', 'library_name', 'VP Central Library', 'string', 'Display name for the library');

-- Insert Sample Library Logs
INSERT INTO library_logs (id, library_id, user_id, entry_time, status, reason) VALUES 
('550e8400-e29b-41d4-a716-446655440060', '550e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440030', NOW() - INTERVAL '2 hours', 'IN', 'Studying'),
('550e8400-e29b-41d4-a716-446655440061', '550e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440031', NOW() - INTERVAL '1 hour', 'IN', 'Research'),
('550e8400-e29b-41d4-a716-446655440062', '550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440033', NOW() - INTERVAL '30 minutes', 'IN', 'Borrowing Books'),
('550e8400-e29b-41d4-a716-446655440063', '550e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440036', NOW() - INTERVAL '15 minutes', 'IN', 'Group Study');

-- Insert Sample Book Borrowings
INSERT INTO book_borrowings (id, library_id, user_id, book_id, borrow_date, due_date, status) VALUES 
('550e8400-e29b-41d4-a716-446655440070', '550e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440030', '550e8400-e29b-41d4-a716-446655440050', NOW() - INTERVAL '5 days', NOW() + INTERVAL '9 days', 'BORROWED'),
('550e8400-e29b-41d4-a716-446655440071', '550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440033', '550e8400-e29b-41d4-a716-446655440053', NOW() - INTERVAL '3 days', NOW() + INTERVAL '12 days', 'BORROWED'),
('550e8400-e29b-41d4-a716-446655440072', '550e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440036', '550e8400-e29b-41d4-a716-446655440055', NOW() - INTERVAL '1 day', NOW() + INTERVAL '9 days', 'BORROWED');
