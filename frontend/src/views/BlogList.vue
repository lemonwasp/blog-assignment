<template>
  <div class="container mt-5">
    <h2>📌 ブログ一覧</h2>

    <!-- 検索入力ウィンドウ -->
    <input
      v-model="searchQuery"
      type="text"
      class="form-control my-3"
      placeholder="検索キーワードを入力..."
    />

    <!-- カテゴリフィルタ -->
    <select v-model="selectedCategory" class="form-select mb-3">
      <option value="">全てのカテゴリ</option>
      <option v-for="category in categories" :key="category.id" :value="category.id">
        {{ category.name }}
      </option>
    </select>

    <!-- フィルター付きブログ投稿のリスト -->
    <ul v-if="filteredPosts.length > 0" class="list-group mt-3">
      <li v-for="post in filteredPosts" :key="post.id" class="list-group-item">
        <router-link :to="'/blogs/' + post.id" class="text-decoration-none">
          {{ post.title }}
        </router-link>
      </li>
    </ul>

    <p v-else>📝 投稿されたブログ記事はありません。</p>
  </div>
</template>

<script>
import { ref, computed, onMounted } from "vue";
import API from "@/utils/api";

export default {
  setup() {
    const posts = ref([]);
    const categories = ref([]); // カテゴリー一覧
    const searchQuery = ref(""); // 検索語
    const selectedCategory = ref(""); // 選択されたカテゴリ

    // ブログ投稿&カテゴリの読み込み
    onMounted(async () => {
      try {
        console.log("ブログ投稿&カテゴリの読み込み開始");
        const [postsResponse, categoriesResponse] = await Promise.all([
          API.get("/blog-posts"),
          API.get("/categories"),
        ]);
        posts.value = postsResponse.data;
        categories.value = categoriesResponse.data;
      } catch (error) {
        console.error("❌ ブログ投稿の読み込み失敗:", error);
      }
    });

    // フィルター付きブログ投稿リスト (検索&カテゴリ適用)
    const filteredPosts = computed(() => {
      return posts.value.filter((post) => {
        const matchesSearch = post.title.toLowerCase().includes(searchQuery.value.toLowerCase());
        const matchesCategory = selectedCategory.value
          ? post.category_id === selectedCategory.value
          : true;
        return matchesSearch && matchesCategory;
      });
    });

    return { posts, categories, searchQuery, selectedCategory, filteredPosts };
  },
};
</script>
