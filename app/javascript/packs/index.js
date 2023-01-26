import { createApp } from 'vue'
import App from '../components/Like/LikeButton.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp(App);
    app.mount("#like")
});