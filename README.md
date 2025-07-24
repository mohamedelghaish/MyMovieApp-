# 🎬 Movie Listing App

An iOS application that displays the top movies of 2025 using The Movie Database (TMDb) API. Built with **Swift**, **UIKit**, **Combine**, and **MVVM architecture**, this app demonstrates offline caching, reactive programming, and clean modular code.

---

## 📱 Features

### ✅ Movie List Screen
- Scrollable list of **top 2025 movies**
- Each movie item displays:
  - Poster thumbnail
  - Title
  - IMDb-style rating
  - Release date
  - Toggleable **Favorite** button
- Tap a movie to view its details

### ✅ Movie Details Screen
- Scrollable layout showing:
  - High-resolution poster
  - Movie title
  - Rating
  - Release date
  - Overview
  - Vote average
  - Original language
  - Favorite/unfavorite toggle (syncs with list)

### ✅ Functionalities
- First launch: Fetch movies from TMDb API
- Subsequent launches: Load from cache
- Offline mode supported
- Persistent favorite status
- Smooth UI with loading and error handling
- Genre tags and horizontal scrolls (just like TMDb)

---

## 🛠 Tech Stack

| Area             | Technology        |
|------------------|-------------------|
| Language         | Swift             |
| UI Framework     | UIKit             |
| Architecture     | MVVM              |
| Reactive Layer   | Combine           |
| Dependency Mgmt  | Swift Package Manager (SPM) |
| Caching          | CoreData + Lightweight image caching |
| Persistence      | CoreData          |
| API              | [TMDb API](https://www.themoviedb.org) |

---

## ⚙️ Setup Instructions

1. **Clone the repository**

```bash
git clone https://github.com/mohamedelghaish/MyMovieApp-.git
