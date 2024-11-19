# My Programming Language Testing Project

[Para a versão em Português Brasileiro clique aqui](./README.md)

This repository contains the implementation of my testing project for programming languages.

> **Note:** I am migrating/rewriting the implementations in the languages I already know, as I lost these implementations over the years.

### List of languages in which this project has been implemented:

1. Python (in migration)  
2. Java (in migration)  
3. Go (in migration)  
4. JavaScript* (in migration)  
5. TypeScript* (in migration)  
6. V (in migration)  
7. Rust (in migration)  
8. Lua (in migration)  
9. Zig  

\* I consider JavaScript and TypeScript to be different languages. While TypeScript is a superset of JavaScript, the development experience (DX) is substantially different.

### List of languages I know but have **not** implemented this project in:

1. Bash  
2. C*  
3. NASM*  

\* NASM and C are very low-level. While I could implement this project in these languages, I don't see a need for it. If I did, it would be solely to demonstrate my development capabilities.

---

## Project Description

### A Library Program

A library management program (for movies, books, etc.; the content doesn't matter) with the following features:

- **CRUD Operations:** Create, Remove, Edit/Update, Search, Display, Help Screen, and Exit.  
- Use **Abstract Data Types (ADTs)** to represent data (Books, Users, etc.). These ADTs are typically structs, classes, etc. Use the appropriate ADT for your chosen language.  
- A **CLI/TUI interface.**  
- A command-line flag to enable a **REST API.**  
- **Encryption, user authentication, and user permissions/hierarchy.**  
- Generation of unique identifiers like UUIDs.  
- Data structured as a **tree** (binary or otherwise) or another suitable data structure.  
- Data stored in a database (preferably SQL).  
- A **multi-threaded and scalable program** with the following structure:
  - One thread for the main program, scalable to support multiple simultaneous inputs.  
  - One thread for the CLI/TUI interface (referred to as a session).  
  - One thread for the REST API (referred to as a session).  
  - One thread for an HTTP server to render responsive, interactive web pages that fetch data synchronously and asynchronously from the REST API. This acts as a basic web development server.  
  - The program must support **multiple simultaneous sessions**, e.g., 3 CLI sessions and 5 REST sessions. Each session should have its own thread.  
  - Exiting a session only terminates its interface. The main server continues running unless it's the only session, in which case the program should prompt or wait for a parameter to terminate the main server.  
  - CRUD operations should prioritize tasks based on computational cost, favoring less expensive tasks over more expensive ones.  
  - The threads must implement at least **two modes of inter-process communication (IPC):** shared memory and message-passing. For example, server-to-session communication should use message-passing (e.g., RPC), while internal server communication should use shared memory. This implies a modular server design.  
- The program should be organized into **multiple files** to test modularity and code compartmentalization.  
- Use the **standard library** of the chosen language as much as possible (preferably exclusively) and leverage the full range of features (e.g., pointers, references) and types (e.g., enums, structs, interfaces) the language provides.  
- The program must handle errors gracefully, providing meaningful messages to the user. It should follow the recommended error-handling practices for the chosen language.  

The program should be well-documented with comments and adhere to the best practices and standards of the chosen language.

### What’s the Goal?

This project is designed to test **all capabilities of a language,** not just specific use cases like “Can it handle AI?” It evaluates scalability, data structures, encryption, and many other areas. By minimizing the use of external frameworks and libraries, I can assess the strengths and weaknesses of the language, such as suitability for web development, back-end processing, or data handling. 

Through this process, I leverage all the features the language offers in the way it’s intended, allowing me to evaluate the language’s philosophy, execution model, and overall developer experience (DX).