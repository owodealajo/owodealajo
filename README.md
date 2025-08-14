# OWODE Digital Services Backend

A comprehensive backend API for OWODE Digital Services - a modern fintech platform providing banking, loans, savings, and payment services.

## Features

- **User Authentication & Authorization**
  - JWT-based authentication
  - Two-factor authentication (2FA)
  - Email verification
  - Password reset functionality

- **Account Management**
  - User profiles and KYC verification
  - Account balance management
  - Transaction history

- **Financial Services**
  - Deposits and withdrawals
  - Money transfers
  - Loan applications and management
  - Savings goals
  - Virtual card management

- **Security Features**
  - Rate limiting
  - Input validation
  - Secure file uploads
  - Email and SMS notifications

## Tech Stack

- **Runtime:** Node.js
- **Framework:** Express.js
- **Database:** MongoDB with Mongoose
- **Authentication:** JWT
- **File Storage:** Cloudinary
- **Email:** Nodemailer
- **SMS:** Twilio
- **Payments:** Stripe
- **Security:** Helmet, bcryptjs, express-rate-limit

## Installation

1. **Clone the repository**
   \`\`\`bash
   git clone <repository-url>
   cd owode-backend
   \`\`\`

2. **Install dependencies**
   \`\`\`bash
   npm install
   \`\`\`

3. **Environment Setup**
   \`\`\`bash
   cp .env.example .env
   \`\`\`
   
   Fill in your environment variables in `.env`:
   - Database connection string
   - JWT secret
   - Email service credentials
   - SMS service credentials (Twilio)
   - Payment gateway keys (Stripe)
   - File storage credentials (Cloudinary)

4. **Start the server**
   \`\`\`bash
   # Development
   npm run dev
   
   # Production
   npm start
   \`\`\`

## API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/verify-email` - Email verification
- `POST /api/auth/forgot-password` - Password reset request
- `POST /api/auth/reset-password` - Password reset
- `POST /api/auth/enable-2fa` - Enable two-factor authentication
- `POST /api/auth/verify-2fa` - Verify 2FA token

### User Management
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile
- `POST /api/users/profile-picture` - Upload profile picture
- `PUT /api/users/change-password` - Change password
- `GET /api/users/balance` - Get account balance

### Transactions
- `GET /api/transactions` - Get user transactions
- `GET /api/transactions/:id` - Get specific transaction
- `POST /api/transactions/deposit` - Make a deposit
- `POST /api/transactions/withdraw` - Make a withdrawal
- `POST /api/transactions/transfer` - Transfer money

### Loans
- `GET /api/loans` - Get user loans
- `POST /api/loans/apply` - Apply for a loan
- `POST /api/loans/:id/documents` - Upload loan documents
- `GET /api/loans/:id` - Get loan details

### Savings
- `GET /api/savings/goals` - Get savings goals
- `POST /api/savings/goals` - Create savings goal
- `POST /api/savings/goals/:id/contribute` - Add money to goal
- `PUT /api/savings/goals/:id` - Update savings goal
- `DELETE /api/savings/goals/:id` - Delete savings goal

## Database Models

### User
- Personal information (name, email, phone, address)
- Authentication data (password, 2FA settings)
- Account details (account number, balance, type)
- Verification status (email, phone, KYC)
- Profile settings

### Transaction
- Transaction details (type, amount, status)
- User reference
- Payment method information
- Recipient details (for transfers)
- Metadata (IP, location, etc.)

### Loan
- Loan application details
- Employment information
- Repayment schedule
- Document uploads
- Status tracking

### Savings Goal
- Goal details (title, target amount, date)
- Progress tracking
- Auto-save settings
- Contribution history

### KYC
- Identity documents
- Address verification
- Income verification
- Risk assessment
- Review status

## Security Features

1. **Authentication & Authorization**
   - JWT tokens with expiration
   - Password hashing with bcrypt
   - Two-factor authentication support

2. **Input Validation**
   - Request validation with express-validator
   - File type and size restrictions
   - SQL injection prevention

3. **Rate Limiting**
   - API rate limiting to prevent abuse
   - Different limits for different endpoints

4. **Data Protection**
   - Sensitive data encryption
   - Secure file uploads
   - CORS configuration

## Deployment

### Environment Variables Required

\`\`\`env
# Server
PORT=5000
NODE_ENV=production

# Database
MONGODB_URI=mongodb://localhost:27017/owode_db

# JWT
JWT_SECRET=your_jwt_secret

# Email (Gmail/SendGrid)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your_email@gmail.com
EMAIL_PASS=your_app_password

# SMS (Twilio)
TWILIO_ACCOUNT_SID=your_twilio_sid
TWILIO_AUTH_TOKEN=your_twilio_token
TWILIO_PHONE_NUMBER=+1234567890

# Payments (Stripe)
STRIPE_SECRET_KEY=sk_live_your_stripe_key
STRIPE_PUBLISHABLE_KEY=pk_live_your_stripe_key

# File Storage (Cloudinary)
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

# Frontend URL
FRONTEND_URL=https://your-frontend-domain.com
\`\`\`

### Production Deployment

1. **Set up MongoDB database**
2. **Configure environment variables**
3. **Set up SSL certificates**
4. **Configure reverse proxy (Nginx)**
5. **Set up process manager (PM2)**
6. **Configure monitoring and logging**

## Testing

\`\`\`bash
# Run tests
npm test

# Run with coverage
npm run test:coverage
\`\`\`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new features
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support, email support@owodedigital.com or create an issue in the repository.
