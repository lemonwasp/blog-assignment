<template>
  <div class="container mt-5">
    <div class="card shadow p-4">
      <!-- タイトル -->
      <h2 class="text-primary fw-bold">{{ post.title }}</h2>
      <p class="text-muted">🕒 {{ formatDate(post.created_at) }}</p>

      <hr />

      <!-- 内容 -->
      <p class="lead">{{ post.content }}</p>

      <!-- カテゴリ表示 -->
      <div class="mt-3">
        <span class="badge bg-info me-2">📌 カテゴリ: {{ post.category?.name || "無し" }}</span>
      </div>

      <!-- タグ表示 -->
      <div class="mt-3">
        <span class="badge bg-warning text-dark me-2" v-for="tag in post.tags" :key="tag.id">
          #{{ tag.name }}
        </span>
      </div>

      <!-- 修整 / 削除ボタン -->
      <div v-if="isAuthor" class="mt-4 d-flex gap-2">
        <router-link :to="`/blogs/${post.id}/edit`" class="btn btn-warning">✏️ 修整</router-link>
        <button @click="deletePost" class="btn btn-danger">🗑 削除</button>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, watchEffect } from "vue";
import { useRoute, useRouter } from "vue-router";
import API from "@/utils/api";
import { useAuthStore } from "@/store/auth";

export default {
  setup() {
    const post = ref({});
    const route = useRoute();
    const router = useRouter();
    const authStore = useAuthStore();
    const isAuthor = ref(false);

    onMounted(async () => {
      try {
        console.log("📢 APIリクエスト開始...");
        const response = await API.get(`/blog-posts/${route.params.id}`);
        post.value = response.data || {};
        console.log("✅ 読み込んだ文データ:", post.value);
      } catch (error) {
        console.error("❌ 読み込みエラー:", error);
      }
    });

    watchEffect(() => {
      console.log("📢 現在のユーザーID:", authStore.userId);
      console.log("📢 作成者ID:", post.value.user_id || "データなし");
      if (post.value.user_id && authStore.userId) {
        isAuthor.value = post.value.user_id === authStore.userId;
        console.log("✅ isAuthor値アップデート:", isAuthor.value);
      }
    });

    const deletePost = async () => {
      if (confirm("本当に削除しますか？")) {
        await API.delete(`/blog-posts/${route.params.id}`);
        router.push("/blogs");
      }
    };

    const formatDate = (dateString) => {
      if (!dateString) return "日付なし";
      return new Date(dateString).toLocaleDateString("ja-JP", {
        year: "numeric",
        month: "long",
        day: "numeric",
      });
    };

    return { post, isAuthor, deletePost, formatDate };
  },
};
</script>

<style scoped>
h2 {
  font-weight: bold;
}

.lead {
  font-size: 1.2rem;
  line-height: 1.6;
}

.badge {
  font-size: 0.9rem;
  padding: 0.5rem;
}
</style>
