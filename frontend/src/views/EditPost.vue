<template>
  <div class="container mt-5">
    <h2>修正</h2>
    <form @submit.prevent="updatePost">
      <div class="mb-3">
        <label class="form-label">タイトル</label>
        <input v-model="title" type="text" class="form-control" required />
      </div>

      <div class="mb-3">
        <label class="form-label">内容</label>
        <textarea v-model="content" class="form-control" rows="5" required></textarea>
      </div>

      <!-- カテゴリー選択 -->
      <div class="mb-3">
        <label class="form-label">カテゴリー</label>
        <select v-model="selectedCategory" class="form-select">
          <option value="">カテゴリー選択</option>
          <option v-for="category in categories" :key="category.id" :value="category.id">
            {{ category.name }}
          </option>
        </select>
      </div>

      <!-- タグ選択 -->
      <div class="mb-3">
        <label class="form-label">タグ</label>
        <div class="d-flex flex-wrap">
          <label v-for="tag in tags" :key="tag.id" class="me-2">
            <input type="checkbox" :value="tag.id" v-model="selectedTags" /> {{ tag.name }}
          </label>
        </div>
      </div>

      <button type="submit" class="btn btn-primary w-100">修正完了</button>
    </form>
  </div>
</template>

<script>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import API from "@/utils/api";

export default {
  setup() {
    const title = ref("");
    const content = ref("");
    const categories = ref([]);
    const tags = ref([]);
    const selectedCategory = ref("");
    const selectedTags = ref([]); // タグ選択配列
    const route = useRoute();
    const router = useRouter();

    onMounted(async () => {
      try {
        // 既存の書き込みデータ、カテゴリ、タグのリストをインポートする
        const [postRes, categoriesRes, tagsRes] = await Promise.all([
          API.get(`/blog-posts/${route.params.id}`),
          API.get("/categories"),
          API.get("/tags"),
        ]);
        title.value = postRes.data.title;
        content.value = postRes.data.content;
        categories.value = categoriesRes.data;
        tags.value = tagsRes.data;
        selectedCategory.value = postRes.data.category_id;
        selectedTags.value = postRes.data.tags.map(tag => tag.id); // 既存のタグ選択
      } catch (error) {
        console.error("データ読み込み失敗:", error);
      }
    });

    const updatePost = async () => {

      try {
        await API.patch(`/blog-posts/${route.params.id}`, {
          title: title.value,
          content: content.value,
          category_id: selectedCategory.value,
          tags: selectedTags.value, // タグフィールド名修正
        });
        alert("記事が更新されました！");
        router.push(`/blogs/${route.params.id}`);
      } catch (error) {
        console.error("修正失敗:", error);
      }
    };

    return { title, content, categories, tags, selectedCategory, selectedTags, updatePost };
  },
};
</script>
