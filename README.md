```markdown
# 🚀 CUET CSE Fest — DevOps Hackathon Project  
## Fully Containerized Microservices Architecture (Gateway + Backend + MongoDB)

This project implements a secure, production-ready microservice architecture using **Docker**, **Docker Compose**, and **Makefile automation**.  
It includes:

- **API Gateway** (public)  
- **Backend Service** (private)  
- **MongoDB with persistent volumes**  
- **Development & Production Docker environments**  
- **Makefile command suite**  
- **Health checks**  
- **Product CRUD API**

Everything runs with **one command**.

---

# 🏗️ Architecture Overview

```

```
                  ┌──────────────────────┐
                  │      Client / UI     │
                  └──────────┬───────────┘
                             │ 5921 (Public)
                  ┌──────────▼───────────┐
                  │     API Gateway      │
                  │     (Express.js)     │
                  └──────────┬───────────┘
                             │ Internal Network
                  ┌──────────▼───────────┐
                  │      Backend API     │
                  │     (Node + TS)      │
                  └──────────┬───────────┘
                             │ Internal Network
                  ┌──────────▼───────────┐
                  │       MongoDB        │
                  │  (Persistent Volume) │
                  └──────────────────────┘
```

```

---

# 🔒 Security Rules  
✔ Only **gateway** is exposed (`5921`)  
✔ Backend (`3847`) is **NOT publicly accessible**  
✔ MongoDB (`27017`) is **NOT exposed**  
✔ Environment variables managed via `.env`

---

# 📁 Project Structure

```

.
├── backend/
│   ├── src/
│   ├── Dockerfile
│   ├── Dockerfile.dev
│   └── package.json
├── gateway/
│   ├── src/
│   ├── Dockerfile
│   ├── Dockerfile.dev
│   └── package.json
├── docker/
│   ├── compose.development.yaml
│   └── compose.production.yaml
├── Makefile
├── .env
└── README.md

````

---

# ⚙️ Environment Variables (.env)

```env
MONGO_INITDB_ROOT_USERNAME=fest_admin
MONGO_INITDB_ROOT_PASSWORD=Fest2025!mongo

MONGO_URI=mongodb://fest_admin:Fest2025!mongo@mongo:27017
MONGO_DATABASE=hackathon_db

BACKEND_PORT=3847
GATEWAY_PORT=5921

NODE_ENV=development
````

---

# 🛠️ Makefile Commands

### Development Mode

| Command                          | Description                          |
| -------------------------------- | ------------------------------------ |
| `make dev-up`                    | Start development stack              |
| `make dev-down`                  | Stop dev stack                       |
| `make dev-build`                 | Rebuild backend & gateway dev images |
| `make dev-logs SERVICE=gateway`  | View service logs                    |
| `make dev-shell SERVICE=backend` | Open shell inside container          |
| `make status`                    | Show running containers              |

---

### Production Mode

| Command                          | Description               |
| -------------------------------- | ------------------------- |
| `make prod-up`                   | Start production          |
| `make prod-down`                 | Stop production           |
| `make prod-build`                | Rebuild production images |
| `make prod-logs SERVICE=gateway` | View logs                 |

---

# ▶️ Running the Project

## Start Development

```bash
make dev-up
```

## Check Containers

```bash
make status
```

---

# ❤️‍🩹 Health Checks

### Gateway

```bash
curl http://localhost:5921/health
```

### Backend via Gateway

```bash
curl http://localhost:5921/api/health
```

Expected:

```json
{"ok":true}
```

---

# 🔒 Backend Security Test

The backend must NOT be exposed publicly:

```bash
curl http://localhost:3847/health
```

Expected:

```
curl: (7) Failed to connect
```

✔ Confirms backend is internal-only.

---

# 🗄️ MongoDB Persistence Test

Before restart:

```bash
curl http://localhost:5921/api/products
```

Restart:

```bash
make dev-down
make dev-up
```

After restart:

```bash
curl http://localhost:5921/api/products
```

✔ Data persists → volume is working.

---

# 🧪 Product API Testing

### Create Product

```bash
curl -X POST http://localhost:5921/api/products \
  -H "Content-Type: application/json" \
  -d '{"name": "Hackathon Product", "price": 99.99}'
```

### List Products

```bash
curl http://localhost:5921/api/products
```

Expected:

```json
[
  {
    "_id": "xxxx",
    "name": "Hackathon Product",
    "price": 99.99
  }
]
```

---

# 🔥 Production Deployment

Start production:

```bash
make prod-up
```

Health checks:

```bash
curl http://localhost:5921/health
curl http://localhost:5921/api/health
```

Stop:

```bash
make prod-down
```

---

# 🧹 Cleanup

| Command              | Description                            |
| -------------------- | -------------------------------------- |
| `make clean`         | Remove dev + prod containers           |
| `make clean-all`     | Remove containers + volumes (reset DB) |
| `make clean-volumes` | Delete Mongo volumes only              |

---

# 🎯 What This Project Demonstrates

✔ Dockerized microservices architecture
✔ API gateway → backend → database communication
✔ Secure internal networking (backend hidden)
✔ Persistent MongoDB storage with volumes
✔ Clean environment configuration
✔ Makefile automation
✔ Separate development + production modes
✔ CI/CD-ready folder structure

---

# 🏁 Conclusion

This project satisfies **all DevOps hackathon requirements** including containerization, security, persistence, API functionality, and operational automation.

```

---
