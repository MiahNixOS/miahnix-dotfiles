# MongoDB Complete Tutorial: Beginner to Advanced

## Table of Contents
1. [Introduction to MongoDB](#introduction-to-mongodb)
2. [Installation and Setup](#installation-and-setup)
3. [Basic Concepts](#basic-concepts)
4. [Beginner: CRUD Operations](#beginner-crud-operations)
5. [Intermediate: Querying and Indexing](#intermediate-querying-and-indexing)
6. [Advanced: Aggregation Pipeline](#advanced-aggregation-pipeline)
7. [Expert: Performance and Scaling](#expert-performance-and-scaling)
8. [MongoDB Atlas and Cloud](#mongodb-atlas-and-cloud)
9. [MongoDB with AI and Modern Features](#mongodb-with-ai-and-modern-features)

---

## Introduction to MongoDB

MongoDB is a leading NoSQL database that stores data in flexible, JSON-like documents called BSON (Binary JSON). Unlike traditional relational databases, MongoDB doesn't require a predefined schema, making it ideal for modern applications with evolving data structures.

### Key Characteristics
- **Document-Oriented**: Stores data in BSON documents similar to JSON
- **Schema-less**: Documents in the same collection can have different structures
- **Scalable**: Designed for horizontal scaling through sharding
- **Flexible**: Supports nested documents and arrays natively
- **High Performance**: Supports indexing, queries, and real-time aggregation

### MongoDB vs Relational Databases

| Aspect | MongoDB | Relational Databases |
|--------|---------|---------------------|
| Data Model | Document-based | Table-based |
| Schema | Dynamic | Fixed |
| Query Language | MongoDB Query Language (MQL) | SQL |
| Joins | Limited (lookup) | Native JOIN support |
| Transactions | Multi-document ACID | Native ACID |

### Use Cases
- Content Management Systems
- Real-time Analytics
- Mobile Applications
- IoT Data Storage
- E-commerce Platforms
- AI and Machine Learning Data Pipelines

---

## Installation and Setup

### Installing MongoDB Community Server

**macOS (using Homebrew)**:
```bash
brew tap mongodb/brew
brew install mongodb-community@7.0
brew services start mongodb-community@7.0
```

**Windows**:
1. Download the MongoDB Community Server installer from mongodb.com
2. Run the installer and follow the setup wizard
3. MongoDB is typically installed at `C:\Program Files\MongoDB\Server\7.0\bin`

**Linux (Ubuntu/Debian)**:
```bash
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | \
   sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
```

### MongoDB Shell (mongosh)

The MongoDB Shell (`mongosh`) is the new interactive MongoDB client, replacing the legacy mongo shell.

**Starting mongosh**:
```bash
# Connect to local instance
mongosh

# Connect to remote instance
mongosh "mongodb://hostname:27017"

# Connect with authentication
mongosh "mongodb://username:password@hostname:27017/?authSource=admin"
```

---

## Basic Concepts

### Database, Collection, and Document

MongoDB's hierarchy follows this structure:

```
Database
  ├── Collection 1
  │   ├── Document 1
  │   ├── Document 2
  │   └── Document 3
  └── Collection 2
      ├── Document 1
      └── Document 2
```

### BSON Data Types

MongoDB supports various data types beyond JSON:

- **String**: `"Hello World"`
- **Number**: `42`, `3.14` (supports 64-bit floating point)
- **Boolean**: `true`, `false`
- **Null**: `null`
- **Date**: `new Date("2026-01-17")`
- **ObjectId**: `ObjectId("507f1f77bcf86cd799439011")`
- **Array**: `[1, 2, 3]`
- **Object/Nested Document**: `{"street": "123 Main St", "city": "NYC"}`
- **Binary Data**: BinData
- **Regular Expression**: `/pattern/flags`
- **Timestamp**: Timestamp

### ObjectId

The default primary key for MongoDB documents:

```javascript
// Generating a new ObjectId
ObjectId()
ObjectId("507f1f77bcf86cd799439011")

// Extracting timestamp from ObjectId
ObjectId("507f1f77bcf86cd799439011").getTimestamp()
// Returns: ISODate("2026-01-15T10:30:00Z")
```

---

## Beginner: CRUD Operations

### Database Commands

```javascript
// Show all databases
show dbs

// Switch to/create a database
use myapp

// Show current database
db

// Show all collections in current database
show collections

// Database statistics
db.stats()

// Drop database
db.dropDatabase()
```

### Collection Commands

```javascript
// Create a collection explicitly
db.createCollection("users")

// Create collection with options
db.createCollection("products", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["name", "price"],
      properties: {
        name: { bsonType: "string" },
        price: { bsonType: "number" }
      }
    }
  }
})

// Drop a collection
db.users.drop()

// Collection statistics
db.users.stats()
```

### Create Operations

**insertOne() - Insert a single document**:

```javascript
db.users.insertOne({
  name: "John Doe",
  email: "john@example.com",
  age: 30,
  address: {
    street: "123 Main St",
    city: "New York",
    zip: "10001"
  },
  tags: ["user", "premium"],
  createdAt: new Date()
})
// Returns: { "acknowledged" : true, "insertedId" : ObjectId("...") }
```

**insertMany() - Insert multiple documents**:

```javascript
db.users.insertMany([
  {
    name: "Jane Smith",
    email: "jane@example.com",
    age: 25
  },
  {
    name: "Bob Johnson",
    email: "bob@example.com",
    age: 35
  },
  {
    name: "Alice Williams",
    email: "alice@example.com",
    age: 28
  }
])
// Returns: { "acknowledged" : true, "insertedIds" : [ ObjectId("..."), ObjectId("..."), ObjectId("...") ] }
```

**Ordered inserts**:

```javascript
// By default, inserts are ordered (stops on error)
db.users.insertMany([
  { name: "User 1", email: "user1@example.com" },
  { name: "User 2", email: "user2@example.com" }
])

// Unordered inserts (continues on error)
db.users.insertMany([
  { name: "User 3", email: "user3@example.com" },
  { name: "User 4", email: "user4@example.com" }
], { ordered: false })
```

### Read Operations

**find() - Query documents**:

```javascript
// Find all documents
db.users.find()

// Find with filter
db.users.find({ age: 30 })

// Find with multiple conditions (AND)
db.users.find({
  age: { $gt: 25 },
  city: "New York"
})

// Find with OR condition
db.users.find({
  $or: [
    { age: { $lt: 25 } },
    { name: "John Doe" }
  ]
})

// Find one document
db.users.findOne({ name: "John Doe" })
```

**Comparison Operators**:

```javascript
// Equal to
db.users.find({ age: 30 })

// Greater than ($gt)
db.users.find({ age: { $gt: 25 } })

// Greater than or equal ($gte)
db.users.find({ age: { $gte: 25 } })

// Less than ($lt)
db.users.find({ age: { $lt: 30 } })

// Less than or equal ($lte)
db.users.find({ age: { $lte: 30 } })

// Not equal ($ne)
db.users.find({ status: { $ne: "inactive" } })

// In array ($in)
db.users.find({ age: { $in: [25, 30, 35] } })

// Not in array ($nin)
db.users.find({ age: { $nin: [20, 40] } })
```

**Logical Operators**:

```javascript
// AND (implicit)
db.users.find({
  age: { $gt: 25 },
  city: "New York"
})

// AND ($and)
db.users.find({
  $and: [
    { age: { $gt: 25 } },
    { city: "New York" }
  ]
})

// OR ($or)
db.users.find({
  $or: [
    { age: { $lt: 25 } },
    { name: "John Doe" }
  ]
})

// NOT ($not)
db.users.find({
  age: { $not: { $lt: 25 } }
})

// NOR ($nor)
db.users.find({
  $nor: [
    { age: { $lt: 25 } },
    { status: "inactive" }
  ]
})
```

**Element Operators**:

```javascript
// Field exists ($exists)
db.users.find({ email: { $exists: true } })
db.users.find({ middleName: { $exists: false } })

// Field type ($type)
db.users.find({ age: { $type: "number" } })
db.users.find({ metadata: { $type: "object" } })
```

**Array Operators**:

```javascript
// Array contains element ($in)
db.users.find({ tags: "premium" })

// Array contains all elements ($all)
db.users.find({ tags: { $all: ["user", "premium"] } })

// Array size ($size)
db.users.find({ tags: { $size: 2 } })

// Element match ($elemMatch)
db.users.find({
  grades: { $elemMatch: { $gte: 90 } }
})
```

**Projection (selecting fields)**:

```javascript
// Include only specific fields
db.users.find({}, { name: 1, email: 1 })

// Exclude _id
db.users.find({}, { name: 1, email: 1, _id: 0 })

// Exclude specific field
db.users.find({}, { age: 0 })

// Include nested fields
db.users.find({}, { "address.city": 1 })

// Array element projection
db.users.find(
  { "grades.grade": "A" },
  { "grades.$": 1 }
)
```

**Cursor Methods**:

```javascript
// Limit results
db.users.find().limit(10)

// Skip results (pagination)
db.users.find().skip(20)

// Sort results
db.users.find().sort({ age: 1 })     // Ascending
db.users.find().sort({ age: -1 })    // Descending
db.users.find().sort({ name: 1, age: -1 })

// Count documents
db.users.countDocuments({ age: { $gt: 25 } })

// Check if any documents exist
db.users.findOne({ email: "john@example.com" }) !== null

// Explain query plan
db.users.find({ age: { $gt: 25 } }).explain()
```

**Pagination Example**:

```javascript
// Page 1 (documents 1-10)
db.users.find().limit(10)

// Page 2 (documents 11-20)
db.users.find().skip(10).limit(10)

// Page 3 (documents 21-30)
db.users.find().skip(20).limit(10)
```

### Update Operations

**updateOne() - Update single document**:

```javascript
// Update first matching document
db.users.updateOne(
  { name: "John Doe" },
  {
    $set: {
      email: "john.doe@example.com",
      age: 31
    },
    $push: {
      tags: "updated"
    }
  }
)
```

**updateMany() - Update multiple documents**:

```javascript
// Update all matching documents
db.users.updateMany(
  { age: { $lt: 30 } },
  {
    $set: {
      status: "young"
    }
  }
)
```

**replaceOne() - Replace document**:

```javascript
// Replace entire document (preserves _id)
db.users.replaceOne(
  { name: "John Doe" },
  {
    name: "John Doe",
    email: "new.email@example.com",
    age: 32,
    status: "active"
  }
)
```

**Update Operators**:

```javascript
// $set - Set field values
db.users.updateOne(
  { name: "John Doe" },
  { $set: { age: 31, status: "premium" } }
)

// $unset - Remove fields
db.users.updateOne(
  { name: "John Doe" },
  { $unset: { temporaryField: "" } }
)

// $inc - Increment/decrement
db.users.updateOne(
  { name: "John Doe" },
  { $inc: { age: 1, loginCount: 1 } }
)

// $mul - Multiply
db.users.updateOne(
  { name: "John Doe" },
  { $mul: { price: 1.1 } }
)

// $min - Set if smaller
db.users.updateOne(
  { name: "John Doe" },
  { $min: { price: 9.99 } }
)

// $max - Set if larger
db.users.updateOne(
  { name: "John Doe" },
  { $max: { price: 99.99 } }
)

// $push - Add to array
db.users.updateOne(
  { name: "John Doe" },
  { $push: { tags: "vip" } }
)

// $push with $each - Add multiple items
db.users.updateOne(
  { name: "John Doe" },
  {
    $push: {
      tags: { $each: ["gold", "premium"] }
    }
  }
)

// $addToSet - Add if not exists
db.users.updateOne(
  { name: "John Doe" },
  { $addToSet: { tags: "vip" } }
)

// $pull - Remove from array
db.users.updateOne(
  { name: "John Doe" },
  { $pull: { tags: "old" } }
)

// $pullAll - Remove multiple values
db.users.updateOne(
  { name: "John Doe" },
  { $pullAll: { tags: ["a", "b"] } }
)

// $pop - Remove first/last array element
db.users.updateOne(
  { name: "John Doe" },
  { $pop: { tags: 1 } }    // Remove last
)

// $rename - Rename field
db.users.updateOne(
  { name: "John Doe" },
  { $rename: { "oldField": "newField" } }
)

// Upsert (update or insert)
db.users.updateOne(
  { name: "New User" },
  {
    $set: { email: "new@example.com", age: 25 },
    $setOnInsert: { createdAt: new Date() }
  },
  { upsert: true }
)
```

### Delete Operations

**deleteOne() - Delete single document**:

```javascript
db.users.deleteOne({ name: "John Doe" })
// Returns: { "acknowledged" : true, "deletedCount" : 1 }
```

**deleteMany() - Delete multiple documents**:

```javascript
db.users.deleteMany({ status: "inactive" })
// Returns: { "acknowledged" : true, "deletedCount" : 5 }
```

**Remove all documents**:

```javascript
db.users.deleteMany({})
// Returns: { "acknowledged" : true, "deletedCount" : 100 }
```

---

## Intermediate: Querying and Indexing

### Query Optimization

**Using explain()**:

```javascript
// Basic explain
db.users.find({ age: { $gt: 25 } }).explain()

// Query execution stats
db.users.find({ age: { $gt: 25 } }).explain("executionStats")

// Full query plan with all stats
db.users.find({ age: { $gt: 25 } }).explain("allPlansExecution")

// Analysis example
var exp = db.users.find({ age: { $gt: 25 } }).explain("executionStats")
printjson(exp.executionStats)
```

### Introduction to Indexes

Indexes are special data structures that improve query performance:

```javascript
// Create single field index
db.users.createIndex({ email: 1 })

// Create compound index
db.users.createIndex({ age: 1, name: 1 })

// Create unique index
db.users.createIndex({ email: 1 }, { unique: true })

// Create sparse index (indexes only non-null values)
db.users.createIndex({ phone: 1 }, { sparse: true })

// Create TTL index (automatic deletion)
db.sessions.createIndex(
  { createdAt: 1 },
  { expireAfterSeconds: 3600 }
)

// Create text index
db.articles.createIndex({ title: "text", content: "text" })

// Create 2dsphere index (geospatial)
db.places.createIndex({ location: "2dsphere" })

// Create hashed index
db.users.createIndex({ _id: "hashed" })

// Create wildcard index
db.products.createIndex({ "attributes.$**": 1 })
```

### Index Types

**Single Field Index**:

```javascript
// Ascending index
db.users.createIndex({ age: 1 })

// Descending index
db.users.createIndex({ age: -1 })
```

**Compound Index**:

```javascript
// Compound index with multiple fields
db.users.createIndex({ status: 1, age: -1, name: 1 })

// Index key order matters
// This index supports:
// - Queries on status only
// - Queries on status and age
// - Queries on status, age, and name
// But NOT queries on age alone
```

**Multikey Index** (for array fields):

```javascript
// Automatically created when indexing array field
db.users.createIndex({ tags: 1 })
// Can query: db.users.find({ tags: "premium" })
```

**Geospatial Indexes**:

```javascript
// 2dsphere for GeoJSON points
db.places.createIndex({ location: "2dsphere" })

// Find places near a point
db.places.find({
  location: {
    $near: {
      $geometry: { type: "Point", coordinates: [-73.97, 40.77] },
      $maxDistance: 1000
    }
  }
})

// 2d for legacy coordinate pairs
db.places.createIndex({ location: "2d" })
```

**Text Indexes**:

```javascript
// Text index for full-text search
db.articles.createIndex({ title: "text", body: "text" })

// Search text
db.articles.find({
  $text: { $search: "mongodb tutorial" }
})

// Text search with relevance score
db.articles.find(
  { $text: { $search: "mongodb database" } },
  { score: { $meta: "textScore" } }
).sort({ score: { $meta: "textScore" } })

// Text index options
db.articles.createIndex(
  { title: "text", body: "text" },
  {
    default_language: "english",
    weights: { title: 10, body: 5 },
    name: "title_body_text"
  }
)
```

**Wildcard Indexes**:

```javascript
// Index all fields in subdocuments
db.products.createIndex({ "properties.$**": 1 })

// Index all array elements
db.users.createIndex({ "hobbies.$**": 1 })
```

### Index Management

```javascript
// List all indexes
db.users.getIndexes()

// Drop index by name
db.users.dropIndex("email_1")

// Drop index by specification
db.users.dropIndex({ age: 1 })

// Drop all indexes
db.users.dropIndexes()

// Rename index
db.users.reIndex()

// Check index size
db.users.totalIndexSize()
```

### Index Build Operations

```javascript
// Background index creation (non-blocking)
db.users.createIndex({ email: 1 }, { background: true })

// Unique index
db.users.createIndex({ email: 1 }, { unique: true })

// Partial index (index only matching documents)
db.users.createIndex(
  { status: 1 },
  { partialFilterExpression: { status: { $exists: true } } }
)

// Conditional partial index
db.users.createIndex(
  { email: 1 },
  {
    partialFilterExpression: {
      $and: [
        { email: { $exists: true } },
        { status: "active" }
      ]
    }
  }
)

// Case-insensitive index
db.users.createIndex({ email: 1 }, { collation: { locale: "en", strength: 2 } })
```

### Covered Queries

```javascript
// Query that only uses indexed fields
db.users.find(
  { email: "john@example.com" },
  { _id: 0, email: 1 }
)
// This query is "covered" by the email index
// MongoDB can answer entirely from the index
```

### Index Performance Tips

```javascript
// Use compound indexes for common query patterns
// Order fields: Equality -> Range -> Sort

// Bad: queries on age + sort by name
// Good compound index: { age: 1, name: 1 }

// Use explain() to verify index usage
db.users.find({ age: { $gt: 25 } }).explain()

// Avoid $ne and $not as they can't use indexes efficiently
// Use $in instead

// Use $exists: false with sparse indexes
```

---

## Advanced: Aggregation Pipeline

### Introduction to Aggregation

The aggregation pipeline processes data through multiple stages:

```javascript
db.orders.aggregate([
  { $match: { status: "completed" } },
  { $group: { _id: "$customerId", total: { $sum: "$amount" } } },
  { $sort: { total: -1 } }
])
```

### Pipeline Stages

**$match - Filter documents**:

```javascript
// Filter at the beginning (uses indexes)
db.orders.aggregate([
  { $match: { status: "completed", orderDate: { $gte: new Date("2026-01-01") } } }
])

// Filter in the middle
db.orders.aggregate([
  { $group: { _id: "$customerId", total: { $sum: "$amount" } } },
  { $match: { total: { $gt: 1000 } } }
])
```

**$project - Reshape documents**:

```javascript
// Include/exclude fields
db.orders.aggregate([
  { $project: { _id: 0, customerId: 1, total: 1, status: 1 } }
])

// Add computed fields
db.orders.aggregate([
  {
    $project: {
      customerId: 1,
      subtotal: { $multiply: ["$quantity", "$price"] },
      tax: { $multiply: ["$quantity", "$price", 0.08] },
      total: { $multiply: ["$quantity", "$price", 1.08] }
    }
  }
])

// Rename fields
db.orders.aggregate([
  {
    $project: {
      orderId: "$_id",
      customer: "$customerId",
      orderDate: 1,
      _id: 0
    }
  }
])

// Conditional projection
db.orders.aggregate([
  {
    $project: {
      orderId: "$_id",
      discountApplied: {
        $cond: { if: { $gte: ["$total", 100] }, then: true, else: false }
      }
    }
  }
])

// $switch for multiple conditions
db.orders.aggregate([
  {
    $project: {
      discount: {
        $switch: {
          branches: [
            { case: { $gte: ["$total", 1000] }, then: 0.15 },
            { case: { $gte: ["$total", 500] }, then: 0.10 },
            { case: { $gte: ["$total", 100] }, then: 0.05 }
          ],
          default: 0
        }
      }
    }
  }
])
```

**$group - Group documents**:

```javascript
// Count all documents
db.orders.aggregate([
  { $group: { _id: null, count: { $sum: 1 } } }
])

// Group by single field
db.orders.aggregate([
  { $group: { _id: "$status", count: { $sum: 1 } } }
])

// Group by multiple fields
db.orders.aggregate([
  {
    $group: {
      _id: { status: "$status", year: { $year: "$orderDate" } },
      count: { $sum: 1 },
      totalAmount: { $sum: "$amount" },
      avgAmount: { $avg: "$amount" },
      minAmount: { $min: "$amount" },
      maxAmount: { $max: "$amount" }
    }
  }
])

// Push values to array
db.orders.aggregate([
  {
    $group: {
      _id: "$customerId",
      orders: { $push: "$orderId" },
      orderDates: { $push: "$orderDate" }
    }
  }
])

// AddToSet (unique values)
db.orders.aggregate([
  {
    $group: {
      _id: "$customerId",
      statuses: { $addToSet: "$status" }
    }
  }
])

// First and last in group
db.orders.aggregate([
  { $sort: { orderDate: 1 } },
  {
    $group: {
      _id: "$customerId",
      firstOrder: { $first: "$$ROOT" },
      lastOrder: { $last: "$$ROOT" }
    }
  }
])
```

**$sort - Sort documents**:

```javascript
// Sort within aggregation
db.orders.aggregate([
  { $sort: { orderDate: -1, amount: 1 } }
])

// Sort after grouping
db.orders.aggregate([
  { $group: { _id: "$customerId", total: { $sum: "$amount" } } },
  { $sort: { total: -1 } }
])
```

**$limit and $skip**:

```javascript
// Get top 10 customers
db.orders.aggregate([
  { $group: { _id: "$customerId", total: { $sum: "$amount" } } },
  { $sort: { total: -1 } },
  { $limit: 10 }
])

// Pagination
db.orders.aggregate([
  { $group: { _id: "$customerId", total: { $sum: "$amount" } } },
  { $sort: { total: -1 } },
  { $skip: 20 },
  { $limit: 10 }
])
```

**$unwind - Deconstruct arrays**:

```javascript
// Unwind array field
db.orders.aggregate([
  { $unwind: "$items" }
])

// Unwind with preserveNullAndEmptyArrays
db.orders.aggregate([
  {
    $unwind: {
      path: "$items",
      preserveNullAndEmptyArrays: true
    }
  }
])
```

**$lookup - Join collections**:

```javascript
// Basic lookup (left outer join)
db.orders.aggregate([
  {
    $lookup: {
      from: "customers",
      localField: "customerId",
      foreignField: "_id",
      as: "customer"
    }
  }
])

// Lookup with pipeline
db.orders.aggregate([
  {
    $lookup: {
      from: "customers",
      let: { customerId: "$customerId" },
      pipeline: [
        { $match: { $expr: { $eq: ["$_id", "$$customerId"] } } },
        { $project: { name: 1, email: 1 } }
      ],
      as: "customer"
    }
  }
])

// Lookup with uncorrelated subquery
db.orders.aggregate([
  {
    $lookup: {
      from: "products",
      pipeline: [
        { $match: { category: "electronics" } },
        { $project: { name: 1, price: 1 } }
      ],
      as: "electronics"
    }
  }
])
```

**$facet - Multiple aggregations in one stage**:

```javascript
db.orders.aggregate([
  {
    $facet: {
      // Group by status
      byStatus: [
        { $group: { _id: "$status", count: { $sum: 1 } } }
      ],
      // Group by customer
      topCustomers: [
        { $group: { _id: "$customerId", total: { $sum: "$amount" } } },
        { $sort: { total: -1 } },
        { $limit: 5 }
      ],
      // Date histogram
      byMonth: [
        {
          $group: {
            _id: {
              year: { $year: "$orderDate" },
              month: { $month: "$orderDate" }
            },
            count: { $sum: 1 }
          }
        }
      ]
    }
  }
])
```

### Aggregation Operators

**Arithmetic Operators**:

```javascript
// $abs, $add, $subtract, $multiply, $divide, $mod, $pow
db.orders.aggregate([
  {
    $project: {
      subtotal: { $multiply: ["$quantity", "$price"] },
      tax: { $multiply: ["$quantity", "$price", 0.08] },
      total: {
        $round: [
          { $add: [
            { $multiply: ["$quantity", "$price"] },
            { $multiply: ["$quantity", "$price", 0.08] }
          ]},
          2
        ]
      }
    }
  }
])
```

**String Operators**:

```javascript
// $concat, $toLower, $toUpper, $substr, $split, $trim
db.users.aggregate([
  {
    $project: {
      fullName: { $concat: ["$firstName", " ", "$lastName"] },
      emailLower: { $toLower: "$email" },
      initials: {
        $concat: [
          { $toUpper: { $substr: ["$firstName", 0, 1] } },
          { $toUpper: { $substr: ["$lastName", 0, 1] } }
        ]
      }
    }
  }
])

// $regexFind for pattern matching
db.users.aggregate([
  {
    $project: {
      emailMatch: {
        $regexFind: {
          input: "$email",
          regex: "@gmail\\.com$"
        }
      }
    }
  }
])
```

**Date Operators**:

```javascript
// $year, $month, $dayOfMonth, $hour, $minute, $second, $dayOfWeek
db.orders.aggregate([
  {
    $project: {
      orderYear: { $year: "$orderDate" },
      orderMonth: { $month: "$orderDate" },
      orderDay: { $dayOfMonth: "$orderDate" },
      dayOfWeek: { $dayOfWeek: "$orderDate" },
      hour: { $hour: "$orderDate" }
    }
  }
])

// $dateFromString, $dateToString
db.orders.aggregate([
  {
    $project: {
      formattedDate: {
        $dateToString: {
          format: "%Y-%m-%d",
          date: "$orderDate"
        }
      }
    }
  }
])

// $dateDiff for calculating differences
db.orders.aggregate([
  {
    $project: {
      daysSinceOrder: {
        $dateDiff: {
          startDate: "$orderDate",
          endDate: new Date(),
          unit: "day"
        }
      }
    }
  }
])
```

**Conditional Operators**:

```javascript
// $cond (if-then-else)
db.orders.aggregate([
  {
    $project: {
      discount: {
        $cond: {
          if: { $gte: ["$amount", 1000] },
          then: 0.15,
          else: { $cond: {
            if: { $gte: ["$amount", 500] },
            then: 0.10,
            else: 0
          }}
        }
      }
    }
  }
])

// $ifNull
db.users.aggregate([
  {
    $project: {
      displayName: { $ifNull: ["$nickname", "$firstName"] }
    }
  }
])

// $switch
db.orders.aggregate([
  {
    $project: {
      category: {
        $switch: {
          branches: [
            { case: { $gte: ["$amount", 1000] }, then: "premium" },
            { case: { $gte: ["$amount", 500] }, then: "standard" }
          ],
          default: "basic"
        }
      }
    }
  }
])
```

**Array Operators**:

```javascript
// $filter
db.orders.aggregate([
  {
    $project: {
      highValueItems: {
        $filter: {
          input: "$items",
          as: "item",
          cond: { $gte: ["$$item.price", 100] }
        }
      }
    }
  }
])

// $map
db.orders.aggregate([
  {
    $project: {
      itemNames: {
        $map: {
          input: "$items",
          as: "item",
          in: "$$item.name"
        }
      }
    }
  }
])

// $reduce
db.orders.aggregate([
  {
    $project: {
      totalTags: {
        $reduce: {
          input: "$tags",
          initialValue: 0,
          in: { $add: ["$$value", "$$this"] }
        }
      }
    }
  }
])

// $slice, $arrayElemAt, $concatArrays
db.orders.aggregate([
  {
    $project: {
      firstItem: { $arrayElemAt: ["$items", 0] },
      firstThreeItems: { $slice: ["$items", 3] }
    }
  }
])

// $in
db.orders.aggregate([
  {
    $project: {
      hasElectronics: {
        $in: ["electronics", "$categories"]
      }
    }
  }
])
```

### Aggregation Performance

```javascript
// Use $match early in pipeline to reduce documents
db.orders.aggregate([
  { $match: { status: "completed" } },    // Filter first
  { $group: { _id: "$customerId", total: { $sum: "$amount" } } }
])

// Use $limit before expensive operations
db.orders.aggregate([
  { $sort: { orderDate: -1 } },
  { $limit: 100 },                        // Limit before grouping
  { $group: { _id: "$customerId", orders: { $push: "$_id" } } }
])

// Allow disk use for large aggregations
db.orders.aggregate([
  { $group: { _id: "$customerId", total: { $sum: "$amount" } } }
], { allowDiskUse: true })

// Use indexes for $sort
db.orders.aggregate([
  { $sort: { orderDate: -1 } },          // Sorts on indexed field
  { $limit: 100 }
])

// Explain aggregation
db.orders.aggregate([
  { $match: { status: "completed" } },
  { $group: { _id: "$customerId", total: { $sum: "$amount" } } }
]).explain()
```

---

## Expert: Performance and Scaling

### Data Modeling Patterns

**Embedded Document Pattern**:

```javascript
// Store related data together
{
  _id: ObjectId("..."),
  name: "John Doe",
  address: {
    street: "123 Main St",
    city: "New York",
    zip: "10001"
  },
  contact: {
    email: "john@example.com",
    phone: "555-1234"
  }
}

// Good for:
// - One-to-few relationships
// - Data that's always accessed together
// - Embedded data is relatively small
```

**Reference Pattern**:

```javascript
// Users collection
{
  _id: ObjectId("507f1f77bcf86cd799439011"),
  name: "John Doe",
  email: "john@example.com"
}

// Orders collection (references users)
{
  _id: ObjectId("..."),
  customerId: ObjectId("507f1f77bcf86cd799439011"),
  orderDate: new Date(),
  items: [...]
}

// Lookup to join
db.orders.aggregate([
  {
    $lookup: {
      from: "users",
      localField: "customerId",
      foreignField: "_id",
      as: "customer"
    }
  }
])

// Good for:
// - One-to-many relationships
// - Frequently changing data
// - Large arrays or documents
```

**Subset Pattern**:

```javascript
// Store only frequently accessed data
{
  _id: ObjectId("..."),
  name: "John Doe",
  email: "john@example.com",
  recentOrders: [
    { orderId: ObjectId("..."), date: new Date(), total: 150 }
  ],
  // Older orders stored separately
  olderOrders: []
}
```

**Bucket Pattern**:

```javascript
// Bucket time-series data
{
  sensorId: "sensor-001",
  date: ISODate("2026-01-15T00:00:00Z"),
  readings: [
    { time: ISODate("2026-01-15T00:00:00Z"), value: 23.5 },
    { time: ISODate("2026-01-15T00:05:00Z"), value: 23.8 },
    // ... 288 readings per day
  ]
}
```

**Polymorphic Pattern**:

```javascript
// Different document types in one collection
{ _id: 1, type: "book", title: "MongoDB Guide", author: "John" }
{ _id: 2, type: "cd", title: "Greatest Hits", artist: "Band" }
{ _id: 3, type: "dvd", title: "Movie", director: "Director" }
```

### Schema Design Anti-Patterns

**Avoid**:
- Massive arrays (use referencing)
- Deeply nested documents (normalize)
- Case-insensitive queries on large datasets
- Non-deterministic updates
- Large documents (>16MB)

### Transactions

```javascript
// Start a session
const session = db.getMongo().startSession()

// Start transaction
session.startTransaction()

try {
  const accounts = session.getDatabase("bank").accounts
  
  // Transfer $100 from account 1 to account 2
  accounts.updateOne(
    { _id: 1 },
    { $inc: { balance: -100 } }
  )
  
  accounts.updateOne(
    { _id: 2 },
    { $inc: { balance: 100 } }
  )
  
  // Commit transaction
  session.commitTransaction()
} catch (error) {
  // Abort transaction on error
  session.abortTransaction()
} finally {
  session.endSession()
}
```

### Read and Write Concerns

```javascript
// Write concern (acknowledgment level)
db.users.insertOne(
  { name: "John" },
  { writeConcern: { w: "majority", j: true, wtimeout: 5000 } }
)

// Read concern
db.users.find(
  { status: "active" },
  { readConcern: { level: "majority" } }
)

// Read preference (where to read from)
db.users.find(
  { status: "active" },
  { readPreference: "secondaryPreferred" }
)
```

### Connection Pooling

```javascript
// MongoDB driver connection pool options
// In Node.js:
const { MongoClient } = require('mongodb')
const client = new MongoClient(uri, {
  maxPoolSize: 100,           // Max connections
  minPoolSize: 10,            // Min connections
  maxIdleTimeMS: 30000,       // Close idle connections
  waitQueueTimeoutMS: 30000   // Timeout for queue
})

// Connection string with options
const uri = "mongodb://host:27017/?maxPoolSize=100&minPoolSize=10"
```

### Performance Monitoring

```javascript
// Database profiler
db.setProfilingLevel(1, { slowms: 100 })  // Profile slow operations

// View profiler logs
db.system.profile.find().limit(10).sort({ ts: -1 })

// Current operations
db.currentOp()

// Kill long-running operation
db.killOp(opId)

// Collection statistics
db.users.stats()

// Index usage statistics
db.users.aggregate([
  { $indexStats: {} }
])
```

### Sharding (Horizontal Scaling)

```javascript
// Shard a collection
sh.enableSharding("mydb")
sh.shardCollection("mydb.users", { userId: 1 })

// Check sharding status
sh.status()

// Add shard
sh.addShard("replicaSetName/mongodb3.example.net:27017")

// Split chunks
sh.splitAt("mydb.users", { userId: 10000 })

// Move chunks
sh.moveChunk(
  "mydb.users",
  { userId: 5000 },
  "newShardName"
)
```

### Replication

```javascript
// Replica set configuration
rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "mongodb0.example.net:27017" },
    { _id: 1, host: "mongodb1.example.net:27017" },
    { _id: 2, host: "mongodb2.example.net:27017" }
  ]
})

// Check replica set status
rs.status()

// Check if secondary is synced
rs.printSecondaryReplicationInfo()

// Force election
rs.stepDown()

// Add arbiter
rs.addArbiter("arbiter.example.net:27017")
```

---

## MongoDB Atlas and Cloud

### MongoDB Atlas Overview

MongoDB Atlas is a fully managed cloud database service:

```javascript
// Connect to Atlas cluster
const uri = "mongodb+srv://<username>:<password>@cluster.mongodb.net/<dbname>?retryWrites=true&w=majority"
```

### Atlas Features

**Automated Backups**:

```javascript
// Point-in-time recovery available in Atlas UI
// Continuous backups with 13-month retention
```

**Atlas Search (Full-Text Search)**:

```javascript
// Atlas Search indexes
// Rich search capabilities with Lucene
db.articles.aggregate([
  {
    $search: {
      text: {
        query: "mongodb tutorial",
        path: ["title", "content"]
      }
    }
  }
])
```

**Atlas Data Federation**:

```javascript
// Query data across Atlas cluster and S3 buckets
// Available through Atlas Data Federation
```

### Atlas Performance Advisor

```javascript
// Index recommendations automatically provided
// Access through Atlas UI
// Shows missing indexes and suggested schemas
```

### Atlas Monitoring

```javascript
// Atlas provides metrics:
// - Operations per second
// - Query performance
// - Memory usage
// - Disk I/O
// - Network throughput

// Custom alerts available in Atlas
```

---

## MongoDB with AI and Modern Features

### Vector Search

MongoDB now supports vector search for AI applications:

```javascript
// Create vector index
db.collection.createIndex(
  { embedding: "vector" },
  {
    dimensions: 768,
    similarity: "cosine",
    dropDups: true
  }
)

// Store embeddings with documents
db.articles.insertOne({
  title: "Introduction to MongoDB",
  content: "MongoDB is a NoSQL database...",
  embedding: [0.123, 0.456, 0.789, ...]  // 768-dimensional vector
})

// Perform vector search
db.articles.aggregate([
  {
    $vectorSearch: {
      index: "vector_index",
      path: "embedding",
      queryVector: [0.111, 0.222, 0.333, ...],
      numCandidates: 100,
      limit: 10
    }
  }
])
```

### Atlas Search with Vector Search

```javascript
// Hybrid search combining text and vector
db.articles.aggregate([
  {
    $search: {
      compound: {
        must: [
          {
            text: {
              query: "database tutorial",
              path: ["title", "content"]
            }
          },
          {
            vectorSearch: {
              path: "embedding",
              queryVector: [0.111, 0.222, 0.333, ...],
              numCandidates: 100,
              limit: 10
            }
          }
        ]
      }
    }
  }
])
```

### Voyage AI Integration

MongoDB's Voyage AI integration provides embedding models:

```javascript
// Generate embeddings using Voyage AI
// Available through Atlas AI Features
// Supports various embedding models for different use cases
```

### Intelligent Query Generation

```javascript
// Natural language to MongoDB queries
// Available in Atlas
// Converts text queries to aggregation pipelines
```

### Building AI Applications

```javascript
// RAG (Retrieval-Augmented Generation) pattern
const pipeline = [
  {
    $vectorSearch: {
      index: "content_embedding",
      queryVector: userQueryEmbedding,
      numCandidates: 10,
      limit: 5
    }
  },
  {
    $project: {
      content: 1,
      score: { $meta: "vectorSearchScore" }
    }
  }
]

// Use retrieved context with LLM
const context = db.documentation.aggregate(pipeline).toArray()
```

---

## Best Practices Summary

### Security
- Enable authentication and authorization
- Use TLS/SSL encryption
- Implement network filtering
- Regular security patches
- Audit logging

### Performance
- Use appropriate indexes
- Monitor with explain()
- Implement connection pooling
- Use read preferences wisely
- Optimize queries

### Scalability
- Design for sharding from the start
- Use appropriate write concerns
- Monitor replica set lag
- Implement proper data modeling

### Backup and Recovery
- Enable continuous backups
- Test restore procedures
- Implement point-in-time recovery
- Regular backup verification

---

## Additional Resources

- MongoDB Documentation: https://www.mongodb.com/docs/
- MongoDB University: https://learn.mongodb.com
- MongoDB Atlas Free Tier: https://www.mongodb.com/cloud/atlas
- MongoDB Community: https://www.mongodb.com/community

---

*Last updated: January 2026*
