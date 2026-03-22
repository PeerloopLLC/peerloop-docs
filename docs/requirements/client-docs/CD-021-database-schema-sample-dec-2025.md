# CD-021: PeerLoop Database Sample (Dec 12, 2025)

**Date Uploaded:** 2025-12-23
**Original Date:** 2025-12-12
**Source File:** `Brians potential database Dec 12, 2025.js`
**Summary for SPECS.md:**

JavaScript mock database file containing sample data structures for PeerLoop's core entities: Creators (instructors) and Courses. Provides concrete schema definitions and sample data that informs database design.

---

## Database Schema Analysis

### Entity 1: Instructors (Creators)

```javascript
{
  id: number,                    // Primary key
  name: string,                  // Display name (e.g., "Guy Rymberg")
  title: string,                 // Professional title (e.g., "AI Prompting Specialist")
  avatar: string,                // URL to profile image
  bio: string,                   // Extended biography (paragraph)
  qualifications: [              // Array of credential objects
    {
      id: number,
      sentence: string           // Full credential statement
    }
  ],
  website: string,               // External website URL
  expertise: string[],           // Array of skill/topic tags (3-6 items typical)
  stats: {
    studentsTaught: number,      // Aggregate across all courses
    coursesCreated: number,      // Count of courses
    averageRating: number,       // Decimal (e.g., 4.8)
    totalReviews: number         // Total review count
  },
  courses: number[]              // Array of course IDs taught
}
```

**Sample Data Insights (8 creators):**
- Stats range: 127-19,928 students taught
- Courses per creator: 1-4
- Ratings: 4.5-4.9 range
- Qualifications: 2-4 per creator (degrees, positions, awards)
- Expertise tags: 4-6 per creator

---

### Entity 2: Courses

```javascript
{
  id: number,                    // Primary key
  title: string,                 // Course title
  description: string,           // Extended description (paragraph)
  duration: string,              // Human-readable (e.g., "6 weeks", "4-6 weeks")
  level: string,                 // "Beginner" | "Intermediate" | "Advanced"
  rating: number,                // Decimal (4.5-4.9 observed)
  students: number,              // Enrollment count
  price: string,                 // Formatted (e.g., "$399")
  thumbnail: string,             // Image URL
  instructorId: number,          // Foreign key to instructors
  category: string,              // Single category classification
  tags: string[],                // Array of topic tags (4-6 typical)
  learningObjectives: string[],  // What students will learn (3-5 items)
  curriculum: [                  // Module structure
    {
      title: string,
      duration: string,          // e.g., "2h 30min", "Week 1"
      description: string,
      // Extended fields (on some courses):
      videos: number,            // Video count per module
      readings: number,          // Reading count per module
      assessment: boolean        // Whether module has assessment
    }
  ],

  // PeerLoop-specific fields (Course 15 only - reference implementation):
  peerloopFeatures: {
    oneOnOneTeaching: boolean,
    certifiedTeachers: boolean,
    earnWhileTeaching: boolean,
    teacherCommission: string    // e.g., "70%"
  },
  studentTeachers: [             // Active Student-Teachers for this course
    {
      name: string,
      studentsTaught: number,
      certifiedDate: string      // e.g., "December 2024"
    }
  ],
  includes: string[]             // What's included (6-8 items)
}
```

**Sample Data Insights (15 courses):**
- Price range: $299-$499 (header comment mentions $300-600 target)
- Duration: 4-12 weeks
- Levels: Beginner (2), Intermediate (8), Advanced (5)
- Students per course: 127-15,678
- Curriculum modules: 3-5 per course

---

## Categories Observed

| Category | Count | Examples |
|----------|-------|----------|
| AI & Product Management | 1 | AI for Product Managers |
| Machine Learning | 1 | Deep Learning Fundamentals |
| Computer Vision | 1 | Computer Vision with Python |
| NLP | 1 | Natural Language Processing |
| Data Science | 1 | Data Science Fundamentals |
| Business Analytics | 1 | Business Intelligence & Analytics |
| Backend Development | 1 | Node.js Backend Development |
| Cloud Computing | 1 | Cloud Architecture with AWS |
| Full-Stack Development | 1 | Full-Stack Web Development |
| DevOps | 1 | DevOps & CI/CD Mastery |
| System Design | 1 | Microservices Architecture |
| AI & Robotics | 1 | AI for Robotics Coding Lab |
| AI in Healthcare | 1 | AI for Medical Diagnostics Coding |
| AI Coding | 1 | AI Coding Bootcamp: Python Projects |
| AI & Prompt Engineering | 1 | AI Prompting Mastery |

---

## PeerLoop Model Confirmation

From the file header comment:
```
PeerLoop Model: Learn → Certify → Teach → Earn (70/15/15 split)
Price Range: $300-600 (1-on-1 tutoring pricing)
```

This confirms existing documentation in CD-001 through CD-020.

---

## Reference Course: AI Prompting Mastery (Course 15)

Course 15 serves as the **reference implementation** for PeerLoop-specific features. It shows:

**PeerLoop Features Block:**
```javascript
peerloopFeatures: {
  oneOnOneTeaching: true,
  certifiedTeachers: true,
  earnWhileTeaching: true,
  teacherCommission: "70%"
}
```

**Student-Teachers Display:**
```javascript
studentTeachers: [
  { name: "Marcus Chen", studentsTaught: 12, certifiedDate: "December 2024" },
  { name: "Jessica Torres", studentsTaught: 8, certifiedDate: "November 2024" },
  { name: "Alex Rivera", studentsTaught: 5, certifiedDate: "January 2025" }
]
```

**Course Includes:**
- Full course access
- 1-on-1 peer teaching sessions
- Certificate on completion
- Lifetime access to materials
- Access to prompt library templates
- Discord community access

**Extended Curriculum (weekly structure):**
- 5 modules over 4-6 weeks
- Tracks videos, readings, and assessments per module
- Module 5 is "Certification Prep" with portfolio review

---

## Helper Functions Defined

The file includes utility functions for data access:

| Function | Purpose |
|----------|---------|
| `getInstructorById(id)` | Find instructor by ID |
| `getCourseById(id)` | Find course by ID |
| `getCoursesByInstructorId(id)` | Get all courses for an instructor |
| `getAllInstructors()` | Return all instructors |
| `getAllCourses()` | Return all courses |
| `getInstructorWithCourses(id)` | Get instructor with populated courses |
| `getIndexedCourses()` | Courses with search index field |
| `getIndexedInstructors()` | Instructors with search index field |

**Search Index Pattern:**
The indexed functions create a `searchIndex` field combining all searchable text (title, description, tags, objectives, curriculum, instructor info) for efficient full-text search.

---

## Technical Implications for SPECS.md

### Database Schema Suggestions

**Users/Creators Table:**
```sql
users (
  id, name, title, avatar_url, bio, website,
  role ENUM('student', 'student_teacher', 'creator'),
  created_at, updated_at
)

user_qualifications (
  id, user_id FK, sentence, display_order
)

user_expertise (
  id, user_id FK, tag
)

user_stats (
  user_id FK, students_taught, courses_created,
  average_rating, total_reviews
  -- could be computed view instead of stored
)
```

**Courses Table:**
```sql
courses (
  id, title, description, duration, level,
  price_cents, thumbnail_url,
  creator_id FK, category_id FK,
  created_at, updated_at
)

course_tags (course_id FK, tag)

course_objectives (course_id FK, objective, display_order)

course_curriculum (
  id, course_id FK, title, duration, description,
  video_count, reading_count, has_assessment,
  module_order
)

course_includes (course_id FK, item, display_order)
```

**Student-Teacher Tracking:**
```sql
student_teachers (
  id, user_id FK, course_id FK,
  certified_date, students_taught,
  is_active
)
```

### New Fields/Features to Consider

| Field | Current Status | Recommendation |
|-------|----------------|----------------|
| Course `level` | Not in CD-018/019 | Add to course schema |
| Course `category` | Implied in CD-013 feed | Formalize taxonomy |
| `learningObjectives` | Not explicit | Add to course detail page |
| `includes` list | Not explicit | Add to course detail page |
| `peerloopFeatures` block | Implied in specs | Make explicit display |
| Extended curriculum (videos/readings) | Minimal in CD-019 | Consider for Phase 2 |

### Confirms Existing Specs

- 70/15/15 revenue split (CD-001, CD-020)
- Student-Teacher certification concept (CD-018)
- Creator profiles with stats (CD-017)
- Course duration/timing (CD-019)
- Rating and review system (implied in CD-018)
- Follow/social features (CD-018)

---

## Data Quality Notes

1. **Sample instructors use placeholder/famous names** - Not real users (Einstein, placeholder avatar URLs)
2. **Guy Rymberg appears to be reference creator** - Realistic data, PeerLoop-specific course
3. **Stats are illustrative** - Wide ranges show expected variance
4. **Prices are strings** - Consider storing as cents (integer) in actual DB
5. **Duration is human-readable** - May need structured format for calculations

---

## Recommendations

### Immediate (MVP Impact)

1. **Add `level` field to course schema** - Beginner/Intermediate/Advanced improves discovery
2. **Add `category` field to course schema** - Required for browse/filter functionality
3. **Add `learningObjectives` to course detail page** - Helps conversion
4. **Formalize `includes` list** - "What you get" is standard for course sales pages

### Phase 2

1. **Extended curriculum tracking** - Video/reading/assessment counts per module
2. **Search index pattern** - Pre-computed searchable text for performance
3. **Student-Teacher directory display** - Show active STs per course with stats

---

## Goals Referenced
- GO-001 (flywheel validation)
- GO-003 (sustainable income)
- GO-011 (learning management)

## Stories Referenced
- US-C001-C003 (course management)
- US-S005 (course detail view)
- US-C008-C010 (creator profiles)

## Stories Added from This Document
- US-S057 (filter by difficulty level)
- US-S058 (browse by category)
- US-S059 (learning objectives display)
- US-S060 (what's included with course)
- US-S061 (per-course Student-Teachers)
- US-C036 (creator expertise tags)

---

*This document was processed from a JavaScript mock database file. The file contains sample/mock data for development purposes, not production data.*
