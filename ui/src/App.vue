<template>
  <div class="min-h-screen bg-gradient-to-br from-metal-900 via-metal-800 to-indigo-900">
    <!-- Background pattern overlay -->
    <div class="fixed inset-0 opacity-10 bg-[radial-gradient(circle_at_1px_1px,_rgb(255_255_255_/_0.15)_1px,_transparent_0)] bg-[length:40px_40px]"></div>

    <!-- Main content -->
    <div class="relative">
      <router-view />
    </div>
  </div>
</template>

<script setup>
// Main app component with metallic/liquid glass background
</script>

<style scoped>
/* Additional app-level styles */
</style>
