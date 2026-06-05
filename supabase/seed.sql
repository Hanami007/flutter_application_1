-- Seed LearnHub minimal demo data
-- Categories
INSERT INTO categories (id, name, description, icon_url) VALUES
('8f3b2072-881c-4b62-b2d9-1ff04c15144b','Development','Web development, mobile apps, and programming languages','developer_mode'),
('035f5240-7cc5-4eb8-bb2f-6571fa79bf77','Design','UI/UX design, graphic design, and video editing','palette'),
('6db8efcc-a477-4c4f-a496-93cb7ce5768e','Data Science','Machine learning, data analytics, and AI models','analytics'),
('c36d2e67-d874-4b53-b09e-711e5491f24d','Business','Marketing, startups, leadership, and finance','business_center'),
('68a2ee3e-67fe-4ec6-89bf-1e64906f23ee','Languages','English, Japanese, Chinese','language');

-- Branches
INSERT INTO branches (id, name, address, city, state, zip_code, phone, latitude, longitude, capacity) VALUES
('b1122cc3-dd44-4ee5-bf66-aa77bb88cc99','LearnHub Siam Square','Floor 4, Siam Square One, Pathum Wan','Bangkok','Bangkok','10330','02-123-4567',13.7444,100.5350,50),
('b2233dd4-ee55-4ff6-c077-bb88cc99ddaa','LearnHub Asoke Center','Floor 12, Exchange Tower, Sukhumvit Road','Bangkok','Bangkok','10110','02-765-4321',13.7360,100.5604,40);

-- Users (instructors / teachers / demo student)
INSERT INTO users (id, email, full_name, created_at, updated_at) VALUES
('1219ee9d-ff46-4cb4-972c-f68482bf4f17','instructor1@example.com','Instructor One',now(),now()),
('a5b7c729-ea21-4f1a-b6d1-92b1cb5705ad','instructor2@example.com','Instructor Two',now(),now()),
('c6a0c5c4-42b7-4aef-b20b-193de3f13c6b','instructor3@example.com','Instructor Three',now(),now()),
('7df20330-8a22-4467-bc85-98317c24a275','teacher1@example.com','Teacher One',now(),now()),
('86cb6c32-2d85-48b5-9017-f3162235c024','teacher2@example.com','Teacher Two',now(),now()),
('00000000-0000-0000-0000-000000000001','student@example.com','Demo Student',now(),now());

-- Teachers (use teacher UUIDs and point to same user ids above)
INSERT INTO teachers (id, user_id, bio, experience_years, rating, created_at) VALUES
('7df20330-8a22-4467-bc85-98317c24a275','7df20330-8a22-4467-bc85-98317c24a275','Senior Flutter instructor',5,4.8,now()),
('86cb6c32-2d85-48b5-9017-f3162235c024','86cb6c32-2d85-48b5-9017-f3162235c024','UI/UX teacher',7,4.7,now());

-- Courses
INSERT INTO courses (id, name, description, category_id, instructor_id, thumbnail_url, price, duration, level, rating, total_students, created_at, updated_at) VALUES
('1121ee2e-fa46-4bb4-952c-f68482bf4f22','Flutter Mobile Development (Masterclass)','Learn Flutter & Dart end-to-end','8f3b2072-881c-4b62-b2d9-1ff04c15144b','1219ee9d-ff46-4cb4-972c-f68482bf4f17','https://images.unsplash.com/photo-1617042375876-a13e36732a04',3500.0,40,'Beginner',4.8,1540,now(),now()),
('2232ff3f-ab57-4cc5-a63d-a79493cf5a33','UI/UX Design Essentials with Figma','Design modern apps with Figma','035f5240-7cc5-4eb8-bb2f-6571fa79bf77','a5b7c729-ea21-4f1a-b6d1-92b1cb5705ad','https://images.unsplash.com/photo-1561070791-26c113006238',2900.0,24,'Intermediate',4.7,890,now(),now());

-- Class sessions (referencing courses, branches and teachers)
INSERT INTO class_sessions (id, course_id, branch_id, teacher_id, session_type, start_time, end_time, capacity, enrolled_count, status, meeting_link, created_at) VALUES
('s1122dd3-ee44-4ff5-bf66-aa77bb88cc99','1121ee2e-fa46-4bb4-952c-f68482bf4f22','b1122cc3-dd44-4ee5-bf66-aa77bb88cc99','7df20330-8a22-4467-bc85-98317c24a275','onsite',now() + interval '1 day' + interval '2 hours', now() + interval '1 day' + interval '5 hours',25,18,'scheduled',NULL,now()),
('s2233ee4-ff55-4006-c077-bb88cc99ddaa','1121ee2e-fa46-4bb4-952c-f68482bf4f22',NULL,'7df20330-8a22-4467-bc85-98317c24a275','online',now() + interval '3 days' + interval '6 hours', now() + interval '3 days' + interval '8 hours',100,45,'scheduled','https://zoom.us/j/1234567890',now());

-- Optional demo booking for the demo student into the online session
INSERT INTO bookings (user_id, class_session_id, booking_date, status, attendance_status, created_at, updated_at)
VALUES ('00000000-0000-0000-0000-000000000001','s2233ee4-ff55-4006-c077-bb88cc99ddaa', now(), 'confirmed', NULL, now(), now());
