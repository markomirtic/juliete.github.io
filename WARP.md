# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

**Habibi Eats** is a food delivery website built as a static web application using vanilla HTML, CSS, and JavaScript. The project showcases Middle Eastern cuisine with a responsive design and includes features like menu browsing, user authentication, shopping cart functionality, and order management.

## Architecture & Code Structure

### Frontend Architecture
The application follows a **traditional multi-page web architecture** with separate HTML files for each major section:

- **Static HTML Pages**: Each page (`index.html`, `menu.html`, `authentication.html`, etc.) is self-contained
- **Bootstrap-based UI**: Uses Bootstrap 5 for responsive design and component styling
- **Vanilla JavaScript**: Client-side interactivity without frameworks
- **PHP Backend Forms**: Server-side processing for contact forms and potentially user registration

### Key Directories & Files

```
/public/              # Production-ready pages (primary entry point)
├── index.html        # Homepage with hero, about, and events sections
├── menu.html         # Restaurant menu with filtering and ordering
├── authentication.html # User login/registration forms
├── Admin.html        # Admin panel for restaurant management
└── Checkout-Flow.html # Order checkout process

/assets/              # Static assets and resources
├── css/              # Custom and vendor stylesheets
├── js/               # JavaScript functionality
├── img/              # Images, icons, and media files
└── vendor/           # Third-party libraries (Bootstrap, AOS, Swiper, etc.)

/forms/               # Server-side PHP processing
├── contact.php       # Contact form handler
└── book-a-table.php  # Table booking form handler

/Project Management files/  # Documentation and project planning artifacts
```

### Component Pattern
- **Template-based**: Uses BootstrapMade's "Restaurantly" template as foundation
- **Modular CSS**: Separate stylesheets for different concerns (`style.css`, `authentication.css`, `header.css`)
- **Component JavaScript**: Functionality split by feature (`main.js` for navigation/UI, `authentication.js` for forms)

### Third-Party Dependencies
- **Bootstrap 5**: UI framework and responsive grid
- **AOS (Animate On Scroll)**: Scroll-based animations
- **Swiper**: Touch slider/carousel functionality
- **GLightbox**: Image/video lightbox
- **Isotope**: Menu filtering and layout
- **jQuery**: DOM manipulation (legacy dependency)

## Development Commands

### Local Development Server

**Option 1: Python HTTP Server (Recommended)**
```bash
# Python 3
python3 -m http.server 8000

# Python 2
python -m SimpleHTTPServer 8000

# Access: http://localhost:8000/public/index.html
```

**Option 2: Node.js HTTP Server**
```bash
# Install globally
npm install -g http-server

# Run server
http-server

# Access: http://localhost:8080/public/index.html
```

**Option 3: PHP Development Server (for full functionality)**
```bash
# For PHP form processing
php -S localhost:8000

# Access: http://localhost:8000/public/index.html
```

### Testing & Validation

**Manual Testing Routes**
```bash
# Test main navigation flow
open http://localhost:8000/public/index.html
open http://localhost:8000/public/menu.html
open http://localhost:8000/public/authentication.html
open http://localhost:8000/public/Admin.html
open http://localhost:8000/public/Checkout-Flow.html
```

**Browser Developer Tools**
```bash
# Check for JavaScript errors
# Validate responsive design breakpoints
# Test form validation in authentication.js
```

### File Structure Commands

**Find all HTML templates**
```bash
find . -name "*.html" -not -path "./.git/*"
```

**Locate CSS and JavaScript files**
```bash
find ./assets -name "*.css" -o -name "*.js"
```

**Check for PHP dependencies**
```bash
find . -name "*.php"
```

## Key Development Patterns

### HTML Structure
- Pages use **semantic HTML5** with proper section/header/main/footer elements
- **Bootstrap grid system** for responsive layouts
- **AOS attributes** for scroll animations (`data-aos="fade-up"`)

### CSS Architecture
- **Mobile-first responsive design** using Bootstrap breakpoints
- **Custom CSS variables** for brand colors (`#cda45e` gold theme)
- **Component-specific stylesheets** loaded per page

### JavaScript Patterns
- **Vanilla JS with modern ES6+** features (arrow functions, const/let)
- **Event delegation** pattern for dynamic content
- **Async/await** for form submissions and API calls
- **Modular functions** with clear separation of concerns

### Form Handling
- **Client-side validation** with real-time error display
- **Progressive enhancement** - works without JavaScript
- **CSRF protection** considerations for PHP backend
- **Async form submission** with JSON API communication

## Page-Specific Notes

### Authentication System (`authentication.js`)
- Dual-panel login/registration UI with animated transitions
- Comprehensive form validation (email format, password strength, phone validation)
- Country selection dropdown with validation
- Error message display system with field-specific targeting

### Menu System (`menu.html` + `main.js`)
- **Isotope.js** filtering for menu categories
- Add-to-cart functionality with local storage
- Price calculation and cart management
- Mobile-responsive menu grid

### Admin Panel (`Admin.html`)
- Restaurant management interface
- Likely connects to backend API for order management
- Admin-specific styling and functionality

## Development Guidelines

### File Organization
- Main development pages are in `/public/` directory
- Root-level HTML files appear to be duplicates or legacy versions
- Always work with files in `/public/` for consistency
- Keep PHP processing files in `/forms/` directory

### Asset Management
- Images stored in logical folders (`/assets/img/menu/`, `/assets/img/chefs/`)
- Vendor libraries in `/assets/vendor/` - avoid modifying directly
- Custom CSS in `/assets/css/` - maintain existing naming conventions

### Form Development
- Use `authentication.js` patterns for client-side validation
- Follow existing error display conventions (`displayErrors()` function)
- PHP forms require proper email configuration in production

### Responsive Design
- Test at Bootstrap breakpoints: 576px, 768px, 992px, 1200px
- Use existing CSS classes before writing custom responsive code
- Maintain mobile-first development approach

## Navigation Patterns
- **Single-page sections** on homepage using smooth scrolling
- **Cross-page navigation** for major features (menu, auth, admin)
- **Hash-based routing** for homepage sections
- **Mobile hamburger menu** with Bootstrap collapse
