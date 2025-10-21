# Vidyalankar Library Management System - Multi-College Architecture

## 🏛️ System Overview

**Vidyalankar Dhyanpeeth Trust** manages three educational institutions:
1. **Vidyalankar School of Information Technology (VSIT)**
2. **Vidyalankar Institute of Technology (VIT)**
3. **Vidyalankar Polytechnic (VP)**

Each college has:
- Independent library systems
- Separate student databases
- Dedicated staff and faculty
- Unique operational requirements

## 🏗️ Project Structure

```
library-management/
├── mvp/                              # Original MVP (Independent)
│   ├── backend/                      # Firebase backend
│   ├── student-app/                  # PWA
│   ├── faculty-dashboard/           # Web dashboard
│   └── esp32/                       # Hardware code
│
├── vidyalankar-app/                  # Full-Fledged Flutter App
│   ├── lib/                         # Flutter source code
│   │   ├── core/                    # Core functionality
│   │   ├── features/                # Feature modules
│   │   ├── shared/                  # Shared components
│   │   └── main.dart                # App entry point
│   ├── assets/                      # Images, fonts, etc.
│   ├── test/                        # Unit tests
│   └── pubspec.yaml                 # Dependencies
│
├── backend-services/                 # Microservices Backend
│   ├── auth-service/                # Authentication service
│   ├── library-service/             # Library management
│   ├── analytics-service/           # Analytics & reporting
│   ├── notification-service/        # Push notifications
│   ├── admin-service/               # Admin management
│   └── api-gateway/                 # API routing
│
├── database/                        # Database schemas
│   ├── postgresql/                  # PostgreSQL schemas
│   ├── migrations/                  # Database migrations
│   └── seeds/                       # Sample data
│
├── docs/                           # Documentation
│   ├── api/                        # API documentation
│   ├── deployment/                 # Deployment guides
│   └── user-guides/                # User manuals
│
└── infrastructure/                 # Infrastructure as Code
    ├── docker/                     # Docker configurations
    ├── kubernetes/                 # K8s manifests
    └── terraform/                  # Infrastructure provisioning
```

## 🎯 Implementation Phases

### **Phase 1: Project Structure & Multi-Tenant Database** (Week 1-2)
- Set up project structure
- Design multi-tenant database schema
- Create PostgreSQL database with college separation
- Implement basic authentication system

### **Phase 2: Flutter App Foundation** (Week 3-4)
- Initialize Flutter project with proper architecture
- Set up state management (Bloc/Cubit)
- Implement navigation system
- Create basic UI components

### **Phase 3: Authentication & College Selection** (Week 5-6)
- Multi-college authentication system
- College selection interface
- Role-based access control
- User profile management

### **Phase 4: Library Management Core** (Week 7-8)
- Student registration and management
- Library entry/exit tracking
- Book borrowing system
- Staff management

### **Phase 5: Real-Time Features** (Week 9-10)
- Real-time occupancy tracking
- Push notifications
- Live updates across colleges
- Offline-first architecture

### **Phase 6: Analytics & Reporting** (Week 11-12)
- Cross-college analytics
- Individual college reports
- Trust-level insights
- Export functionality

### **Phase 7: Admin Dashboard** (Week 13-14)
- Trust-level administration
- College-specific management
- User management
- System configuration

### **Phase 8: Testing & Deployment** (Week 15-16)
- Comprehensive testing
- Performance optimization
- Production deployment
- User training

## 🗄️ Multi-Tenant Database Schema

### Core Tables
```sql
-- Trust Management
CREATE TABLE trusts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,
    config JSONB,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Colleges
CREATE TABLE colleges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trust_id UUID REFERENCES trusts(id),
    name VARCHAR(255) NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL, -- VSIT, VIT, VP
    type VARCHAR(100) NOT NULL, -- Engineering, Polytechnic, etc.
    address JSONB,
    config JSONB,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Libraries
CREATE TABLE libraries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    college_id UUID REFERENCES colleges(id),
    name VARCHAR(255) NOT NULL,
    code VARCHAR(50) NOT NULL,
    capacity INTEGER DEFAULT 0,
    config JSONB,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Users (Students, Staff, Faculty)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    college_id UUID REFERENCES colleges(id),
    user_type VARCHAR(50) NOT NULL, -- student, staff, faculty, admin
    student_id VARCHAR(50), -- College-specific student ID
    employee_id VARCHAR(50), -- For staff/faculty
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20),
    fcm_token TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(college_id, student_id),
    UNIQUE(college_id, employee_id)
);

-- Library Logs
CREATE TABLE library_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    library_id UUID REFERENCES libraries(id),
    user_id UUID REFERENCES users(id),
    entry_time TIMESTAMP NOT NULL,
    exit_time TIMESTAMP,
    reason TEXT,
    device_id VARCHAR(100),
    status VARCHAR(20) DEFAULT 'IN', -- IN, OUT
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Books
CREATE TABLE books (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    library_id UUID REFERENCES libraries(id),
    isbn VARCHAR(20),
    title VARCHAR(500) NOT NULL,
    author VARCHAR(255),
    publisher VARCHAR(255),
    category VARCHAR(100),
    total_copies INTEGER DEFAULT 1,
    available_copies INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Book Borrowing
CREATE TABLE book_borrowings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    library_id UUID REFERENCES libraries(id),
    user_id UUID REFERENCES users(id),
    book_id UUID REFERENCES books(id),
    borrow_date TIMESTAMP NOT NULL,
    due_date TIMESTAMP NOT NULL,
    return_date TIMESTAMP,
    status VARCHAR(20) DEFAULT 'BORROWED', -- BORROWED, RETURNED, OVERDUE
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

## 🎨 Flutter App Architecture

### State Management: Bloc Pattern
```dart
// Example: College Selection Bloc
class CollegeSelectionBloc extends Bloc<CollegeSelectionEvent, CollegeSelectionState> {
  final CollegeRepository collegeRepository;
  
  CollegeSelectionBloc({required this.collegeRepository}) 
      : super(CollegeSelectionInitial()) {
    on<LoadColleges>(_onLoadColleges);
    on<SelectCollege>(_onSelectCollege);
  }
  
  Future<void> _onLoadColleges(
    LoadColleges event,
    Emitter<CollegeSelectionState> emit,
  ) async {
    emit(CollegeSelectionLoading());
    try {
      final colleges = await collegeRepository.getColleges();
      emit(CollegeSelectionLoaded(colleges: colleges));
    } catch (error) {
      emit(CollegeSelectionError(error.toString()));
    }
  }
}
```

### Feature-Based Architecture
```dart
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── college_selection/
│   ├── library/
│   ├── books/
│   ├── analytics/
│   └── profile/
├── shared/
│   ├── widgets/
│   ├── models/
│   └── services/
└── main.dart
```

## 🔐 Multi-College Authentication Flow

### Authentication States
1. **Trust Login**: User logs in with trust credentials
2. **College Selection**: Choose from VSIT, VIT, or VP
3. **Role Assignment**: Student, Staff, Faculty, or Admin
4. **Library Access**: Access college-specific library features

### User Roles & Permissions
```dart
enum UserRole {
  student,
  staff,
  faculty,
  librarian,
  collegeAdmin,
  trustAdmin
}

class Permission {
  final String resource;
  final String action;
  final List<UserRole> allowedRoles;
  
  const Permission({
    required this.resource,
    required this.action,
    required this.allowedRoles,
  });
}

class Permissions {
  static const List<Permission> all = [
    Permission(
      resource: 'library',
      action: 'enter',
      allowedRoles: [UserRole.student, UserRole.staff, UserRole.faculty],
    ),
    Permission(
      resource: 'books',
      action: 'borrow',
      allowedRoles: [UserRole.student, UserRole.staff, UserRole.faculty],
    ),
    Permission(
      resource: 'analytics',
      action: 'view',
      allowedRoles: [UserRole.librarian, UserRole.collegeAdmin, UserRole.trustAdmin],
    ),
  ];
}
```

## 📱 Flutter App Features

### Core Features
- **Multi-College Login**: Select college after authentication
- **Student Portal**: Library access, book borrowing, notifications
- **Staff Portal**: Library management, student assistance
- **Faculty Portal**: Research resources, analytics access
- **Admin Portal**: Cross-college management, reporting

### Advanced Features
- **Offline Mode**: Work without internet connection
- **Push Notifications**: Real-time alerts and updates
- **QR Code Scanning**: Quick book and student identification
- **Biometric Login**: Fingerprint/Face ID authentication
- **Dark Mode**: Theme customization
- **Multi-Language**: Support for multiple languages

## 🚀 Getting Started

Let's begin with **Phase 1: Project Structure & Multi-Tenant Database**

### Step 1: Create Project Structure
```bash
# Create the main project structure
mkdir -p library-management/vidyalankar-app
mkdir -p library-management/backend-services
mkdir -p library-management/database
mkdir -p library-management/docs
mkdir -p library-management/infrastructure

# Initialize Flutter project
cd library-management/vidyalankar-app
flutter create . --org com.vidyalankar.library
```

### Step 2: Set Up Database
```bash
# Create PostgreSQL database
createdb vidyalankar_library

# Run initial migrations
psql vidyalankar_library < database/migrations/001_initial_schema.sql
```

### Step 3: Configure Backend Services
```bash
# Set up microservices
cd ../backend-services
mkdir auth-service library-service analytics-service notification-service admin-service api-gateway

# Initialize each service
cd auth-service && npm init -y
cd ../library-service && npm init -y
# ... repeat for each service
```

## 📊 Success Metrics

### Technical Metrics
- **Multi-Tenant Support**: 3 colleges with independent data
- **User Capacity**: 10,000+ students across all colleges
- **Performance**: <2s app load time, <500ms API response
- **Offline Capability**: 100% core features work offline

### Business Metrics
- **Adoption Rate**: 90%+ student usage across all colleges
- **Efficiency**: 50% reduction in library management time
- **User Satisfaction**: 4.5+ star rating
- **ROI**: 300%+ return on investment for the trust

## 🎯 Next Steps

1. **Create the project structure** (Phase 1)
2. **Set up PostgreSQL database** with multi-tenant schema
3. **Initialize Flutter project** with proper architecture
4. **Implement authentication system** for multi-college access
5. **Build core library management features**

The system will be designed so that:
- **MVP continues to work independently** for testing/demo purposes
- **Flutter app operates completely separately** with its own backend
- **Both systems can coexist** without interference
- **Easy migration path** from MVP to full app when ready

Ready to start with Phase 1? Let's build this step by step! 🚀
