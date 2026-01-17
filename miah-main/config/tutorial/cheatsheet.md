# MongoDB Cheat Sheet

## Table of Contents
1. [Connection & Shell Commands](#connection--shell-commands)
2. [Database Operations](#database-operations)
3. [Collection Operations](#collection-operations)
4. [CRUD Operations](#crud-operations)
5. [Query Operators](#query-operators)
6. [Update Operators](#update-operators)
7. [Aggregation Pipeline](#aggregation-pipeline)
8. [Indexing](#indexing)
9. [Transactions](#transactions)
10. [Data Modeling](#data-modeling)
11. [Replication & Sharding](#replication--sharding)
12. [MongoDB Atlas](#mongodb-atlas)

---

## Connection & Shell Commands

```bash
# Connect to local instance
mongosh

# Connect to remote instance
mongosh "mongodb://hostname:27017"

# Connect with authentication
mongosh "mongodb://user:pass@host:27017/?authSource=admin"

# Connect to Atlas cluster
mongosh "mongodb+srv://cluster.mongodb.net/dbname"

# Execute JavaScript file
mongosh --file script.js

# Quiet mode (no startup messages)
mongosh --quiet

# Help
mongosh --help
```

```javascript
// Shell help
help
help db
help collection

// Show all databases
show dbs
show databases

// Switch database
use mydb

// Show current database
db

// Exit shell
exit
quit
Ctrl+D
```

---

## Database Operations

```javascript
// Show all databases
show dbs

// Create or switch to database
use myapp

// Current database stats
db.stats()

// Drop current database
db.dropDatabase()

// Get database version
db.version()

// Run JavaScript
db.adminCommand({ eval: "print('hello')" })
```

---

## Collection Operations

```javascript
// List collections
show collections
show tables

// Create collection
db.createCollection("users")

// Create collection with options
db.createCollection("products", {
  capped: true,
  size: 1000000,
  max: 10000,
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

// Drop collection
db.users.drop()

// Collection stats
db.users.stats()
db.users.dataSize()
db.users.totalSize()
db.users.storageSize()

// Rename collection
db.users.renameCollection("customers")

// Check if collection exists
db.getCollectionNames().includes("users")
```

---

## CRUD Operations

### Insert

```javascript
// Insert one document
db.users.insertOne({
  name: "John",
  email: "john@example.com",
  age: 30
})

// Insert multiple documents
db.users.insertMany([
  { name: "Jane", email: "jane@example.com" },
  { name: "Bob", email: "bob@example.com" }
])

// Insert with ordered (default: true)
db.users.insertMany([...], { ordered: true })

// Insert or upsert
db.users.updateOne(
  { email: "john@example.com" },
  { $set: { name: "John" } },
  { upsert: true }
)
```

### Find (Read)

```javascript
// Find all documents
db.users.find()

// Find with filter
db.users.find({ age: 30 })
db.users.find({ age: { $gt: 25 } })

// Find one document
db.users.findOne({ name: "John" })

// Projection (select fields)
db.users.find({}, { name: 1, email: 1 })
db.users.find({}, { _id: 0, name: 1 })  // Exclude _id
db.users.find({}, { age: 0 })           // Exclude age

// Limit results
db.users.find().limit(10)

// Skip results
db.users.find().skip(20)

// Sort results
db.users.find().sort({ age: 1 })        // Ascending
db.users.find().sort({ age: -1 })       // Descending
db.users.find().sort({ name: 1, age: -1 })

// Count documents
db.users.countDocuments({ age: { $gt: 25 } })
db.users.estimatedDocumentCount()        // Faster, uses metadata

// Distinct values
db.users.distinct("age")
db.users.distinct("status", { age: { $gt: 25 } })

// Check existence
db.users.findOne({ email: "john@example.com" }) !== null

// Query cursor methods
db.users.find().hasNext()
db.users.find().next()
db.users.find().forEach(function(doc) { print(doc.name) })

// Explain query
db.users.find({ age: { $gt: 25 } }).explain()
db.users.find({ age: { $gt: 25 } }).explain("executionStats")
```

### Update

```javascript
// Update one (first match)
db.users.updateOne(
  { name: "John" },
  { $set: { age: 31 } }
)

// Update many (all matches)
db.users.updateMany(
  { age: { $lt: 25 } },
  { $set: { status: "young" } }
)

// Replace document (preserves _id)
db.users.replaceOne(
  { name: "John" },
  { name: "John", email: "new@example.com", age: 32 }
)

// Update operators
db.users.updateOne(
  { name: "John" },
  {
    $set: { age: 31, status: "active" },
    $inc: { loginCount: 1 },
    $push: { tags: "vip" },
    $addToSet: { tags: "premium" }  // Add if not exists
  }
)

// Update with upsert
db.users.updateOne(
  { email: "new@example.com" },
  { $set: { name: "New User" } },
  { upsert: true }
)

// Array updates
db.users.updateOne(
  { name: "John" },
  { $push: { grades: 95 } }
)

db.users.updateOne(
  { name: "John" },
  { $push: { grades: { $each: [90, 85, 92] } } }
)

db.users.updateOne(
  { name: "John" },
  { $pull: { grades: { $lt: 70 } } }
)

db.users.updateOne(
  { name: "John" },
  { $pop: { grades: 1 } }  // Remove last
)

// Array with positional operator
db.users.updateOne(
  { name: "John", "grades.score": 85 },
  { $set: { "grades.$.score": 90 } }
)

// Array filtering (MongoDB 3.6+)
db.users.updateOne(
  { name: "John" },
  {
    $set: {
      "grades.$[elem].score": 95
    }
  },
  { arrayFilters: [{ "elem.score": { $lt: 70 } }] }
)
```

### Delete

```javascript
// Delete one
db.users.deleteOne({ name: "John" })

// Delete many
db.users.deleteMany({ status: "inactive" })

// Delete all
db.users.deleteMany({})

// Remove (legacy, similar to delete)
db.users.remove({ name: "John" })
db.users.remove({ name: "John" }, { justOne: true })
```

---

## Query Operators

### Comparison Operators

```javascript
// Equal to
{ field: value }
{ field: { $eq: value } }

// Greater than
{ field: { $gt: value } }

// Greater than or equal
{ field: { $gte: value } }

// Less than
{ field: { $lt: value } }

// Less than or equal
{ field: { $lte: value } }

// Not equal
{ field: { $ne: value } }

// In array
{ field: { $in: [value1, value2, value3] } }

// Not in array
{ field: { $nin: [value1, value2] } }
```

### Logical Operators

```javascript
// AND (implicit)
{ field1: value1, field2: value2 }

// AND (explicit)
{ $and: [ { field1: value1 }, { field2: value2 } ] }

// OR
{ $or: [ { field1: value1 }, { field2: value2 } ] }

// NOT
{ field: { $not: { $gt: value } } }

// NOR
{ $nor: [ { field1: value1 }, { field2: value2 } ] }
```

### Element Operators

```javascript
// Field exists
{ field: { $exists: true } }
{ field: { $exists: false } }

// Field type
{ field: { $type: "string" } }
{ field: { $type: "number" } }
{ field: { $type: "array" } }
{ field: { $type: "object" } }
{ field: { $type: "date" } }
{ field: { $type: "null" } }

// Type aliases
// "double", "string", "object", "array", "binData"
// "undefined", "objectId", "bool", "date", "null"
// "regex", "javascript", "int", "long", "decimal"
```

### Evaluation Operators

```javascript
// Regex
{ name: /^John/ }
{ name: { $regex: "^John", $options: "i" } }

// Modulo
{ age: { $mod: [10, 0] } }  // age divisible by 10

// Text search (requires text index)
{ $text: { $search: "mongodb tutorial" } }
{ $text: { $search: "\"exact phrase\"" } }

// Where (JavaScript expression)
{ $where: "this.age > 25" }
```

### Array Operators

```javascript
// Array contains element
{ tags: "premium" }

// Array contains all elements
{ tags: { $all: ["premium", "vip"] } }

// Array length
{ tags: { $size: 3 } }

// Element matches condition
{ grades: { $elemMatch: { $gte: 90 } } }

// Array element at index
{ "grades.0": 95 }
```

### Bitwise Operators

```javascript
// All bits set
{ flags: { $bitsAllSet: [1, 2, 4] } }

// Any bits set
{ flags: { $bitsAnySet: [1, 2, 4] } }

// All bits clear
{ flags: { $bitsAllClear: [1, 2, 4] } }

// Any bits clear
{ flags: { $bitsAnyClear: [1, 2, 4] } }
```

### Geospatial Operators

```javascript
// Near (2D)
db.places.find({
  location: {
    $near: [ -73.97, 40.77 ],
    $maxDistance: 0.1
  }
})

// Near with GeoJSON
db.places.find({
  location: {
    $near: {
      $geometry: { type: "Point", coordinates: [-73.97, 40.77] },
      $maxDistance: 1000
    }
  }
})

// Within polygon
db.places.find({
  location: {
    $geoWithin: {
      $geometry: {
        type: "Polygon",
        coordinates: [[ [0,0], [10,0], [10,10], [0,10], [0,0] ]]
      }
    }
  }
})

// Intersects
db.places.find({
  location: {
    $geoIntersects: {
      $geometry: { type: "Point", coordinates: [-73.97, 40.77] }
    }
  }
})
```

---

## Update Operators

### Field Update Operators

```javascript
// Set field value
{ $set: { field: value } }
{ $set: { "address.city": "NYC", "address.zip": "10001" } }

// Unset field
{ $unset: { field: "" } }

// Increment
{ $inc: { field: 1 } }
{ $inc: { field: -1 } }

// Multiply
{ $mul: { price: 1.1 } }

// Rename field
{ $rename: { oldField: "newField" } }

// Set on insert (only when upserting)
{ $setOnInsert: { createdAt: new Date() } }

// Min (set if smaller)
{ $min: { price: 9.99 } }

// Max (set if larger)
{ $max: { price: 99.99 } }

// Current date
{ $currentDate: { lastModified: true } }
{ $currentDate: { timestamp: { $type: "timestamp" } } }
```

### Array Update Operators

```javascript
// Add to array
{ $push: { field: value } }
{ $push: { field: { $each: [value1, value2] } } }

// Add to array if not exists
{ $addToSet: { field: value } }
{ $addToSet: { field: { $each: [value1, value2] } } }

// Remove from array
{ $pull: { field: value } }
{ $pull: { field: { $gte: 80 } } }
{ $pull: { tags: { $in: ["old", "unused"] } } }

// Remove all matching
{ $pullAll: { field: [value1, value2] } }

// Remove first/last
{ $pop: { field: 1 } }   // Remove last
{ $pop: { field: -1 } }  // Remove first

// Position operator
{ $: { "grades.$.score": 95 } }

// Array filters
{
  $set: {
    "grades.$[elem].score": 100
  }
},
{ arrayFilters: [{ "elem.grade": "A" }] }
```

---

## Aggregation Pipeline

### Pipeline Stages

```javascript
// $match - Filter documents
{ $match: { status: "completed" } }

// $project - Reshape documents
{ $project: { _id: 0, name: 1, total: 1 } }

// $group - Group documents
{ $group: { _id: "$status", count: { $sum: 1 } } }

// $sort - Sort documents
{ $sort: { total: -1 } }

// $limit - Limit documents
{ $limit: 10 }

// $skip - Skip documents
{ $skip: 20 }

// $unwind - Deconstruct arrays
{ $unwind: "$items" }
{ $unwind: { path: "$items", preserveNullAndEmptyArrays: true } }

// $lookup - Join collections
{
  $lookup: {
    from: "customers",
    localField: "customerId",
    foreignField: "_id",
    as: "customer"
  }
}

// $lookup with pipeline
{
  $lookup: {
    from: "customers",
    let: { cid: "$customerId" },
    pipeline: [
      { $match: { $expr: { $eq: ["$_id", "$$cid"] } } }
    ],
    as: "customer"
  }
}

// $addFields - Add fields
{ $addFields: { total: { $multiply: ["$price", "$quantity"] } } }

// $set - Add/replace fields (4.2+)
{ $set: { newField: "value" } }

// $unset - Remove fields (4.2+)
{ $unset: "temporaryField" }

// $replaceRoot - Replace root document
{
  $replaceRoot: {
    newRoot: {
      $mergeObjects: [
        { $arrayToObject: { $objectToArray: "$$ROOT" } },
        "$details"
      ]
    }
  }
}

// $replaceWith - Replace with single document (4.2+)
{ $replaceWith: "$customer" }

// $facet - Multiple aggregations
{
  $facet: {
    output1: [ { $group: { ... } } ],
    output2: [ { $sort: { ... } }, { $limit: 5 } ]
  }
}

// $bucket - Categorize documents
{
  $bucket: {
    groupBy: "$age",
    boundaries: [0, 18, 30, 50, 100],
    default: "Other",
    output: { count: { $sum: 1 } }
  }
}

// $bucketAuto - Auto-categorize
{
  $bucketAuto: {
    groupBy: "$price",
    buckets: 5,
    output: { count: { $sum: 1 } }
  }
}

// $graphLookup - Recursive lookup
{
  $graphLookup: {
    from: "employees",
    startWith: "$reportsTo",
    connectFromField: "reportsTo",
    connectToField: "_id",
    as: "reportingHierarchy"
  }
}
```

### Aggregation Operators

```javascript
// Arithmetic
{ $add: [ "$price", "$tax" ] }
{ $subtract: [ "$total", "$discount" ] }
{ $multiply: [ "$price", "$quantity" ] }
{ $divide: [ "$total", "$count" ] }
{ $mod: [ "$total", 3 ] }
{ $abs: "$value" }
{ $round: [ "$value", 2 ] }
{ $ceil: "$value" }
{ $floor: "$value" }

// String
{ $toUpper: "$name" }
{ $toLower: "$name" }
{ $concat: ["$firstName", " ", "$lastName"] }
{ $substr: [ "$name", 0, 5 ] }
{ $substrBytes: [ "$name", 0, 5 ] }
{ $split: [ "$email", "@" ] }
{ $trim: { input: " $name ", chars: " " } }
{ $ltrim: { input: " $name " } }
{ $rtrim: { input: " $name " } }
{ $regexFind: { input: "$text", regex: "pattern" } }
{ $regexMatch: { input: "$text", regex: "pattern" } }

// Date
{ $year: "$orderDate" }
{ $month: "$orderDate" }
{ $dayOfMonth: "$orderDate" }
{ $dayOfWeek: "$orderDate" }
{ $dayOfYear: "$orderDate" }
{ $hour: "$orderDate" }
{ $minute: "$orderDate" }
{ $second: "$orderDate" }
{ $millisecond: "$orderDate" }
{ $dateToString: { format: "%Y-%m-%d", date: "$orderDate" } }
{ $dateFromString: { dateString: "2026-01-15" } }
{ $dateDiff: { startDate: "$start", endDate: "$end", unit: "day" } }

// Conditional
{ $cond: [ { $gte: ["$amount", 1000] }, 0.15, 0 ] }
{
  $switch: {
    branches: [
      { case: { $gte: ["$amount", 1000] }, then: 0.15 },
      { case: { $gte: ["$amount", 500] }, then: 0.10 }
    ],
    default: 0
  }
}
{ $ifNull: [ "$nickname", "$firstName" ] }
{ $isNumber: "$value" }

// Array
{ $arrayToObject: "$pairs" }
{ $objectToArray: "$object" }
{
  $map: {
    input: "$items",
    as: "item",
    in: { $multiply: ["$$item.price", "$$item.quantity"] }
  }
}
{
  $filter: {
    input: "$items",
    as: "item",
    cond: { $gte: ["$$item.price", 100] }
  }
}
{ $range: [0, 10, 2] }
{ $reduce: {
    input: "$tags",
    initialValue: "",
    in: { $concat: ["$$value", "$$this"] }
  }}
{ $zip: { inputs: ["$array1", "$array2"] } }
{ $indexOfArray: [ "$array", value ] }
{ $arrayElemAt: [ "$array", 0 ] }
{ $first: "$array" }
{ $last: "$array" }
{ $in: [ value, "$array" ] }
{ $size: "$array" }
{ $slice: [ "$array", 5 ] }
{ $reverseArray: "$array" }

// Accumulators (used in $group)
{ $sum: 1 }
{ $sum: "$amount" }
{ $avg: "$amount" }
{ $min: "$amount" }
{ $max: "$amount" }
{ $push: "$orderId" }
{ $addToSet: "$status" }
{ $first: "$value" }
{ $last: "$value" }
{ $stdDevPop: "$amount" }
{ $stdDevSamp: "$amount" }

// Type expressions
{ $type: "$value" }
{ $convert: { input: "$value", to: "string" } }
{ $toBool: "$value" }
{ $toString: "$value" }
{ $toInt: "$value" }
{ $toLong: "$value" }
{ $toDouble: "$value" }
{ $toDate: "$value" }
```

### Aggregation Options

```javascript
// Allow disk use for large aggregations
db.orders.aggregate([...], { allowDiskUse: true })

// Specify cursor batch size
db.orders.aggregate([...], { cursor: { batchSize: 100 } })

// Collation
db.orders.aggregate([...], { collation: { locale: "en", strength: 2 } })
```

---

## Indexing

### Create Indexes

```javascript
// Single field index
db.users.createIndex({ email: 1 })
db.users.createIndex({ email: -1 })

// Compound index
db.users.createIndex({ status: 1, age: -1, name: 1 })

// Unique index
db.users.createIndex({ email: 1 }, { unique: true })

// Sparse index (skips null values)
db.users.createIndex({ phone: 1 }, { sparse: true })

// TTL index (automatic deletion)
db.sessions.createIndex({ createdAt: 1 }, { expireAfterSeconds: 3600 })

// Text index
db.articles.createIndex({ title: "text", body: "text" })

// Text index with weights
db.articles.createIndex(
  { title: "text", body: "text" },
  { weights: { title: 10, body: 5 } }
)

// Text index with language
db.articles.createIndex(
  { content: "text" },
  { default_language: "spanish" }
)

// 2dsphere index (geospatial)
db.places.createIndex({ location: "2dsphere" })

// 2d index (legacy)
db.places.createIndex({ location: "2d" })

// Hashed index
db.users.createIndex({ _id: "hashed" })

// Wildcard index
db.products.createIndex({ "attributes.$**": 1 })

// Partial index
db.users.createIndex(
  { email: 1 },
  { partialFilterExpression: { status: "active" } }
)

// Covering index
db.users.createIndex({ email: 1, name: 1 })

// Case-insensitive index
db.users.createIndex(
  { email: 1 },
  { collation: { locale: "en", strength: 2 } }
)

// Background index (non-blocking)
db.users.createIndex({ email: 1 }, { background: true })
```

### Index Management

```javascript
// List indexes
db.users.getIndexes()

// Drop index by name
db.users.dropIndex("email_1")

// Drop index by spec
db.users.dropIndex({ age: 1 })

// Drop all indexes
db.users.dropIndexes()

// Rename index
db.users.reIndex()

// Hide index (4.4+)
db.users.hideIndex("email_1")

// Unhide index
db.users.unhideIndex("email_1")

// Check index usage
db.users.find({ email: "test@example.com" }).explain()
```

### Index Types Summary

| Type | Syntax | Use Case |
|------|--------|----------|
| Single Field | `{ field: 1 }` | Queries on single field |
| Compound | `{ a: 1, b: 1 }` | Multi-field queries |
| Multikey | Auto for arrays | Array field queries |
| Text | `{ field: "text" }` | Full-text search |
| 2dsphere | `{ loc: "2dsphere" }` | Geo queries |
| 2d | `{ loc: "2d" }` | Legacy geo |
| Hashed | `{ _id: "hashed" }` | Sharding |
| Wildcard | `{ "field.$**": 1 }` | Dynamic fields |
| TTL | `{ time: 1 }` | Auto-expiry |
| Partial | `{ ... }` | Conditional indexing |

---

## Transactions

```javascript
// Start session
const session = db.getMongo().startSession()

// Start transaction
session.startTransaction()

try {
  const db = session.getDatabase("bank")
  
  // Perform operations
  db.accounts.updateOne(
    { _id: 1 },
    { $inc: { balance: -100 } }
  )
  
  db.accounts.updateOne(
    { _id: 2 },
    { $inc: { balance: 100 } }
  )
  
  // Commit
  session.commitTransaction()
} catch (error) {
  // Rollback
  session.abortTransaction()
} finally {
  session.endSession()
}

// With retry
async function transfer(session, fromId, toId, amount) {
  while (true) {
    try {
      session.startTransaction()
      // ... operations
      await session.commitTransaction()
      break
    } catch (error) {
      if (error.hasErrorLabel("TransientTransactionError")) {
        continue
      }
      throw error
    }
  }
}
```

---

## Data Modeling

### Patterns

```javascript
// Embedded pattern
{
  _id: 1,
  name: "John",
  address: {
    street: "123 Main",
    city: "NYC",
    zip: "10001"
  },
  orders: [
    { orderId: 101, date: new Date(), total: 150 }
  ]
}

// Reference pattern
// Users collection
{ _id: 1, name: "John" }

// Orders collection
{
  _id: 101,
  customerId: 1,
  date: new Date(),
  total: 150
}

// Bucket pattern (time-series)
{
  sensorId: "sensor-001",
  date: ISODate("2026-01-15"),
  readings: [
    { time: ISODate(...), value: 23.5 },
    { time: ISODate(...), value: 23.8 }
  ]
}

// Polymorphic pattern
{ _id: 1, type: "book", title: "Book", author: "John" }
{ _id: 2, type: "cd", title: "Music", artist: "Band" }
```

### Schema Validation

```javascript
// Add validator to existing collection
db.runCommand({
  collMod: "users",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["name", "email"],
      properties: {
        name: {
          bsonType: "string",
          description: "Name is required"
        },
        email: {
          bsonType: "string",
          pattern: "^.+@.+$"
        },
        age: {
          bsonType: "number",
          minimum: 0,
          maximum: 150
        }
      }
    }
  }
})

// Validation rules
// - $jsonSchema: JSON Schema validation
// - validator: Query expression validation
// - validationLevel: strict (default), moderate, off
// - validationAction: error (default), warn
```

---

## Replication & Sharding

### Replica Set Commands

```javascript
// Initialize replica set
rs.initiate()
rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "mongodb0.example.net:27017" },
    { _id: 1, host: "mongodb1.example.net:27017" },
    { _id: 2, host: "mongodb2.example.net:27017" }
  ]
})

// Status
rs.status()
rs.isMaster()
rs.printReplicationInfo()

// Add member
rs.add("mongodb3.example.net:27017")
rs.add({ _id: 3, host: "mongodb3.example.net:27017", priority: 0, hidden: true })

// Remove member
rs.remove("mongodb2.example.net:27017")

// Configuration
rs.conf()
rs.reconfig(config)

// Election
rs.stepDown()
rs.freeze(300)  // Prevent election for 300 seconds

// Arbiter
rs.addArbiter("arbiter.example.net:27017")

// Tag sets
// For custom write concern
```

### Sharding Commands

```javascript
// Enable sharding on database
sh.enableSharding("mydb")

// Shard collection
sh.shardCollection("mydb.users", { userId: 1 })
sh.shardCollection("mydb.orders", { customerId: 1, orderDate: 1 })

// Shard status
sh.status()
sh.printShardingStatus()

// Add shard
sh.addShard("replicaSetName/mongodb1.example.net:27017")
sh.addShard("mongodbstandalone.example.net:27017")

// Remove shard
sh.removeShard("mongodbstandalone.example.net:27017")

// Split chunks
sh.splitAt("mydb.users", { userId: 10000 })

// Move chunk
sh.moveChunk(
  "mydb.users",
  { userId: 5000 },
  "newShardName"
)

// Balancer
sh.getBalancerState()
sh.startBalancer()
sh.stopBalancer()
sh.isBalancerRunning()
```

### Connection String Format

```javascript
// Standalone
mongodb://host:27017

// Replica Set
mongodb://host1:27017,host2:27017,host3:27017/?replicaSet=rsName

// Sharded Cluster
mongodb://host1:27017,host2:27017/dbname?authSource=admin

// Atlas
mongodb+srv://cluster.mongodb.net/dbname

// With options
mongodb://user:pass@host:27017/dbname?
  authSource=admin&
  replicaSet=rsName&
  readPreference=secondaryPreferred&
  w=majority&
  wtimeout=5000
```

---

## MongoDB Atlas

### Connection

```javascript
// Atlas connection string
mongodb+srv://<username>:<password>@cluster<id>..mongodb.net/<dbname>?retryWrites=true&w=majority

// Connect with mongosh
mongosh "mongodb+srv://cluster.mongodb.net/test" --username <user>
```

### Atlas Search

```javascript
// Create Atlas Search index (in Atlas UI or API)

// Text search
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

// Compound search
db.articles.aggregate([
  {
    $search: {
      compound: {
        must: [
          {
            text: {
              query: "database",
              path: "content"
            }
          }
        ],
        should: [
          {
            text: {
              query: "tutorial",
              path: "title",
              boost: 2
            }
          }
        ]
      }
    }
  }
])

// Faceted search
db.articles.aggregate([
  {
    $search: {
      facet: {
        operator: {
          text: { query: "mongodb", path: "content" }
        },
        facets: {
          category: { type: "string", path: "category" },
          year: { type: "number", path: "year" }
        }
      }
    }
  }
])
```

### Vector Search (Atlas)

```javascript
// Create vector index (Atlas UI)

// Store document with embedding
db.documentation.insertOne({
  title: "MongoDB Guide",
  content: "MongoDB is a NoSQL database...",
  embedding: [0.123, 0.456, 0.789, ...]  // Vector
})

// Vector search
db.documentation.aggregate([
  {
    $vectorSearch: {
      index: "vector_index",
      path: "embedding",
      queryVector: [0.111, 0.222, 0.333, ...],
      numCandidates: 100,
      limit: 10
    }
  },
  {
    $project: {
      title: 1,
      content: 1,
      score: { $meta: "vectorSearchScore" }
    }
  }
])
```

### Atlas CLI

```bash
# Install Atlas CLI
brew install mongodb-atlas-cli

# Authenticate
atlas auth login

# List clusters
atlas clusters list

# Create cluster
atlas cluster create myCluster --region US_EAST_1 --mdbVersion 7.0

# Deploy changes
atlas clusters apply --file cluster-config.json
```

---

## Useful Commands Reference

```javascript
// Get server status
db.adminCommand({ serverStatus: 1 })

// Get build info
db.adminCommand({ buildInfo: 1 })

// List commands
db.adminCommand({ listCommands: 1 })

// Current operations
db.currentOp()
db.currentOp({ active: true })

// Kill operation
db.killOp(opId)

// Set profiling level
db.setProfilingLevel(1, { slowms: 100 })  // 0=off, 1=slow, 2=all

// View profile
db.system.profile.find().limit(5).sort({ ts: -1 })

// Get host info
db.adminCommand({ hostInfo: 1 })

// List users
db.getUsers()

// Create user
db.createUser({
  user: "myuser",
  pwd: "mypassword",
  roles: [{ role: "readWrite", db: "mydb" }]
})

// Drop user
db.dropUser("myuser")

// Role management
db.createRole({
  role: "myRole",
  privileges: [{ resource: { db: "mydb", collection: "users" }, actions: ["find", "update"] }],
  roles: []
})

// Server parameters
db.adminCommand({ getParameter: 1, featureCompatibilityVersion: 1 })

// Rotate log
db.adminCommand({ logRotate: 1 })
```

---

*Last updated: January 2026*
