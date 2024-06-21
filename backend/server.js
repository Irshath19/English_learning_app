const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const { Buffer } = require('buffer');
const cors = require('cors');
const app = express();

// Enable CORS
app.use(cors());

// Increase the JSON payload limit for large video files
app.use(bodyParser.json({ limit: '500mb' })); 

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/englearn', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Define video schema for general videos
const videoSchema = new mongoose.Schema({
  name: String, // Video name field
  data: Buffer, // Store video data as Buffer
  contentType: String, // Specify content type (e.g., 'video/mp4')
});

// Define video schema for vocabulary videos
const vocalSchema = new mongoose.Schema({
  name: String, // Video name field
  data: Buffer, // Store video data as Buffer
  contentType: String, // Specify content type (e.g., 'video/mp4')
});

// Create models for video and vocabulary collections
const Video = mongoose.model('Video', videoSchema);
const Vocabulary = mongoose.model('Vocabulary', vocalSchema);

// Endpoint to upload vocabulary video
app.post('/vocalupload', async (req, res) => {
  try {
    const { video, filename } = req.body;

    if (!video || !filename) {
      return res.status(400).send('Video data or filename missing');
    }

    const videoBuffer = Buffer.from(video, 'base64');
    const newVideo = new Vocabulary({
      name: filename,
      data: videoBuffer,
      contentType: 'video/mp4',
    });

    await newVideo.save();
    res.status(200).send('Video uploaded successfully');
  } catch (error) {
    console.error('Error uploading video:', error);
    res.status(500).send('Failed to upload video');
  }
});

// Endpoint to upload general video
app.post('/upload', async (req, res) => {
  try {
    const { video, filename } = req.body;

    if (!video || !filename) {
      return res.status(400).send('Video data or filename missing');
    }

    const videoBuffer = Buffer.from(video, 'base64');
    const newVideo = new Video({
      name: filename,
      data: videoBuffer,
      contentType: 'video/mp4',
    });

    await newVideo.save();
    res.status(200).send('Video uploaded successfully');
  } catch (error) {
    console.error('Error uploading video:', error);
    res.status(500).send('Failed to upload video');
  }
});

// Endpoint to get a vocabulary video by name
app.get('/video/:videoName', async (req, res) => {
  const { videoName } = req.params;

  try {
    const video = await Vocabulary.findOne({ name: videoName });

    if (!video) {
      return res.status(404).json({ error: 'Video not found' });
    }

    res.status(200).json({ videoData: video.data.toString('base64') });
  } catch (error) {
    console.error('Error fetching video:', error);
    res.status(500).json({ error: 'Failed to fetch video' });
  }
});

// Endpoint to get a list of all vocabulary names
app.get('/vocabularies', async (req, res) => {
  try {
    const vocabularies = await Vocabulary.find({}, 'name');
    res.status(200).json(vocabularies);
  } catch (error) {
    console.error('Error fetching vocabularies:', error);
    res.status(500).json({ error: 'Failed to fetch vocabularies' });
  }
});

// Start the server
app.listen(3000, () => {
  console.log('Server started on port 3000');
});


// const express = require('express');
// const bodyParser = require('body-parser');
// const mongoose = require('mongoose');
// const { Buffer } = require('buffer');
// const cors = require('cors');
// const app = express();
// app.use(cors());
// app.use(bodyParser.json({ limit: '50mb' })); 

// mongoose.connect('mongodb://localhost:27017/videos', {
//   useNewUrlParser: true,
//   useUnifiedTopology: true,
// });

// const videoSchema = new mongoose.Schema({
//   name: String, // Video name field
//   data: Buffer, // Store video data as Buffer
//   contentType: String, // Specify content type (e.g., 'video/mp4')
// });

// const vocalschema = new mongoose.Schema({
//   name: String, // Video name field
//   data: Buffer, // Store video data as Buffer
//   contentType: String, // Specify content type (e.g., 'video/mp4')
// });

// const Video = mongoose.model('Video', videoSchema);
// const Vocabulary=mongoose.model('vocabulary',vocalschema);

// app.post('/vocalupload', async (req, res) => {
//   try {
//     const { video, filename } = req.body;

//     if (!video || !filename) {
//       return res.status(400).send('Video data or filename missing');
//     }

//     const videoBuffer = Buffer.from(video, 'base64');
//     const newVideo = new Vocabulary({
//       name: filename,
//       data: videoBuffer,
//       contentType: 'video/mp4',
//     });

//     await newVideo.save();
//     res.status(200).send('Video uploaded successfully');
//   } catch (error) {
//     console.error('Error uploading video:', error);
//     res.status(500).send('Failed to upload video');
//   }
// });

// app.post('/upload', async (req, res) => {
//   try {
//     const { video, filename } = req.body;

//     if (!video || !filename) {
//       return res.status(400).send('Video data or filename missing');
//     }

//     const videoBuffer = Buffer.from(video, 'base64');
//     const newVideo = new Video({
//       name: filename,
//       data: videoBuffer,
//       contentType: 'video/mp4',
//     });

//     await newVideo.save();
//     res.status(200).send('Video uploaded successfully');
//   } catch (error) {
//     console.error('Error uploading video:', error);
//     res.status(500).send('Failed to upload video');
//   }
// });

// app.get('/video/:videoName', async (req, res) => {
//   const { videoName } = req.params;

//   try {
//     const video = await Vocabulary.findOne({ name: videoName });

//     if (!video) {
//       return res.status(404).json({ error: 'Video not found' });
//     }

//     res.status(200).json({ videoData: video.data.toString('base64') });
//   } catch (error) {
//     console.error('Error fetching video:', error);
//     res.status(500).json({ error: 'Failed to fetch video' });
//   }
// });

// app.get('/vocabularies', async (req, res) => {
//   try {
//     const vocabularies = await Vocabulary.find({}, 'name');
//     res.status(200).json(vocabularies);
//   } catch (error) {
//     console.error('Error fetching vocabularies:', error);
//     res.status(500).json({ error: 'Failed to fetch vocabularies' });
//   }
// });

// // Start server
// app.listen(3000, () => {
//   console.log('Server started on port 3000');
// });



// const express = require('express');
// const bodyParser = require('body-parser');
// const mongoose = require('mongoose');
// const { Buffer } = require('buffer');
// const cors = require('cors');

// const app = express();
// app.use(cors());
// app.use(bodyParser.json({ limit: '500mb' })); 

// mongoose.connect('mongodb://localhost:27017/videos', {
//   useNewUrlParser: true,
//   useUnifiedTopology: true,
// });

// const videoSchema = new mongoose.Schema({
//   name: String, // Video name field
//   data: Buffer, // Store video data as Buffer
//   contentType: String, // Specify content type (e.g., 'video/mp4')
// });
// const vocalschema = new mongoose.Schema({
//   name: String, // Video name field
//   data: Buffer, // Store video data as Buffer
//   contentType: String, // Specify content type (e.g., 'video/mp4')
// });

// const Video = mongoose.model('Video', videoSchema);
// const Vocabulary=mongoose.model('vocabulary',vocalschema);



// app.post('/upload', async (req, res) => {
//   try {
//     const { video, filename } = req.body;

//     if (!video || !filename) {
//       return res.status(400).send('Video data or filename missing');
//     }

//     // Ensure video data is a base64 string
//     if (typeof video !== 'string' || !video.startsWith('data:video/mp4;base64,')) {
//       return res.status(400).send('Invalid video data');
//     }

//     // Strip the data URL prefix if present
//     const videoData = video.replace(/^data:video\/\w+;base64,/, '');
//     const videoBuffer = Buffer.from(videoData, 'base64');

//     const newVideo = new Video({
//       name: filename,
//       data: videoBuffer,
//       contentType: 'video/mp4', // Adjust content type based on your video format
//     });

//     await newVideo.save();
//     res.status(200).send('Video uploaded successfully');
//   } catch (error) {
//     console.error('Error uploading video:', error);
//     res.status(500).send('Failed to upload video');
//   }
// });

// app.get('/video/:videoName', async (req, res) => {
//   const { videoName } = req.params;

//   try {
//     const video = await Video.findOne({ name: videoName });

//     if (!video) {
//       return res.status(404).json({ error: 'Video not found' });
//     }

//     res.status(200).json({ videoData: video.data.toString('base64') });
//   } catch (error) {
//     console.error('Error fetching video:', error);
//     res.status(500).json({ error: 'Failed to fetch video' });
//   }
// });

// app.post('/vocalupload', async (req, res) => {
//   try {
//     const { video, filename } = req.body;

//     if (!video || !filename) {
//       return res.status(400).send('Video data or filename missing');
//     }

//     const videoBuffer = Buffer.from(video, 'base64');
//     const newVideo = new Vocabulary({
//       name: filename,
//       data: videoBuffer,
//       contentType: 'video/mp4',
//     });

//     await newVideo.save();
//     res.status(200).send('Video uploaded successfully');
//   } catch (error) {
//     console.error('Error uploading video:', error);
//     res.status(500).send('Failed to upload video');
//   }
// });

// app.get('/vocabularies', async (req, res) => {
//   try {
//     const vocabularies = await Video.find({}, 'name');
//     res.status(200).json(vocabularies);
//   } catch (error) {
//     console.error('Error fetching vocabularies:', error);
//     res.status(500).json({ error: 'Failed to fetch vocabularies' });
//   }
// });

// // Start server
// app.listen(3000, () => {
//   console.log('Server started on port 3000');
// });


