
# Analyzing Musical Moods: Major vs. Minor Streaming Trends

This project, created for a friendly competition held by the **Data Science Association** at Boston University, explores trends in music streaming data. By analyzing a dataset of songs from Spotify, the project examines how the total number of streams has changed over time and investigates patterns in musical moods (Major vs. Minor modes).

---

##  Project Structure

### **Key Files**
- `spotify-2023.csv`: Dataset containing information about songs, their streams, and features such as BPM, key, mode, and more.
- `stream_trends_analysis.R`: R script used for cleaning, transforming, and visualizing the data.
- `README.md`: Project documentation.

### **Key Folders**
- **`data/`**: Contains the dataset used for this project.
- **`plots/`**: Generated visualizations, including stream trends over time.

---

## Dataset Overview

### **Source**
The dataset `spotify-2023.csv` contains information on songs streamed on Spotify, including:
- **Track Information**: Song name, artist(s), release year, month, and day.
- **Streaming Metrics**: Streams on Spotify, Apple Music, and other platforms.
- **Audio Features**: BPM, key, mode (Major/Minor), danceability, energy, acousticness, etc.

### Detailed Data Set is in the folder.


##  Data Cleaning and Transformation

1. **Cleaning**
   - Renamed column names to **snake_case** for consistency.
   - Converted `streams` from character to numeric, handling missing values with the column median.
   - Addressed NA values in `streams` and `in_shazam_charts` using:
     ```R
     mutate(streams = if_else(is.na(streams), median(streams, na.rm = TRUE), streams))
     ```

2. **Transformation**
   - Combined `released_year`, `released_month`, and `released_day` into a single `released_date` column.
   - Filtered data into time ranges for targeted visual analysis:
     - **1930–1970**, **1970–1980**, **1980–1990**, etc.

---

##  Data Visualization

The project visualizes trends in music streams over different time periods and compares **Major** vs. **Minor** modes. Visualizations were created using the **`ggplot2`** and **`patchwork`** libraries.

### Key Visualizations:
1. **Streams Over Time**
   - Split into six time periods:
     - 1930–1970
     - 1970–1980
     - 1980–1990
     - 1990–2000
     - 2000–2010
     - 2010–2023
   - Line charts for each period with points colored by musical mode (Major/Minor).
   - Example:
     ```R
     ggplot(spotify_1970_1980, aes(x = released_date, y = streams)) +
       geom_point(aes(color = mode)) +
       geom_smooth() +
       labs(title = "1970-1980")
     ```

2. **Overall Mood Trends**
   - Compared Major and Minor modes across decades.
   - Observed increasing diversity in popular music.





## Key Insights

- **Streaming Trends**:
  - Streams have increased significantly since the 1990s, reflecting the rise of digital music platforms.
  - Modern songs (post-2010) dominate streaming metrics, with some exceeding 1 billion streams.

- **Major vs. Minor Modes**:
  - Major modes tend to dominate in earlier decades, while Minor modes have grown more popular in recent years.
  - This shift may reflect changes in listener preferences and evolving music styles.

---

##  Future Work

- Expand the analysis to include genres or regional preferences.
- Explore relationships between audio features (e.g., energy, valence) and streaming performance.
- Integrate additional platforms like YouTube or TikTok to analyze broader trends.

