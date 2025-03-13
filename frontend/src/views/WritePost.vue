<template>
  <div class="container mt-5">
    <div class="card shadow p-4">
      <h2 class="text-center text-primary">📝 新規投稿</h2>

      <form @submit.prevent="createPost">
        <div class="mb-3">
          <label class="form-label">タイトル</label>
          <input v-model="title" type="text" class="form-control" placeholder="タイトルを入力してください" required />
        </div>

        <div class="mb-3">
          <label class="form-label">内容</label>
          <textarea v-model="content" class="form-control" rows="5" placeholder="内容を入力してください" required></textarea>
        </div>

        <div class="row">
          <div class="col-md-6">
            <label class="form-label">カテゴリ</label>
            <select v-model="selectedCategory" class="form-select">
              <option value="">カテゴリを選択</option>
              <option v-for="category in categories" :key="category.id" :value="category.id">
                {{ category.name }}
              </option>
            </select>
          </div>

          <div class="col-md-6">
            <label class="form-label">タグ</label>
            <div class="d-flex flex-wrap">
              <label v-for="tag in tags" :key="tag.id" class="me-2">
                <input type="checkbox" :value="parseInt(tag.id)" v-model="selectedTags" class="form-check-input" />
                {{ tag.name }}
              </label>
            </div>
          </div>
        </div>

        <button type="submit" class="btn btn-primary w-100 mt-3">🚀 作成完了</button>
      </form>
    </div>
  </div>
</template>


<script>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import API from "@/utils/api";

export default {
  setup() {
    const title = ref("");
    const content = ref("");
    const categories = ref([]);
    const tags = ref([]);
    const selectedCategory = ref("");
    const selectedTags = ref([]);
    const router = useRouter();

    onMounted(async () => {
      try {
        const [categoriesRes, tagsRes] = await Promise.all([
          API.get("/categories"),
          API.get("/tags"),
        ]);
        categories.value = categoriesRes.data;
        tags.value = tagsRes.data;
      } catch (error) {
        console.error("❌ カテゴリ&タグのインポートに失敗:", error);
      }
    });

    const createPost = async () => {

      // 既存の変換ロジックで問題が発生 → 「Object.values」を削除し、直接配列に変換
      const tagArray = Array.isArray(selectedTags.value) ? selectedTags.value : Object.values(selectedTags.value);

      try {
        await API.post("/blog-posts", {
          title: title.value,
          content: content.value,
          category_id: selectedCategory.value || null,
          tags: tagArray, // 正しいタグ配列伝達
        });
        alert("作成完了！");
        router.push("/blogs");
      } catch (error) {
        console.error("書き込みエラー:", error);
      }
    };


    return { title, content, categories, tags, selectedCategory, selectedTags, createPost };
  },
};
</script>
