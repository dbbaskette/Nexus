<template>
  <div class="min-h-screen p-8">
    <!-- Header -->
    <header class="mb-12">
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-5xl font-bold mb-2 text-metal-gradient animate-float">
            Nexus Gateway
          </h1>
          <p class="text-gray-400 text-lg">Model Context Protocol Management Console</p>
        </div>
        <nav class="flex gap-4">
          <router-link
            v-for="link in navLinks"
            :key="link.path"
            :to="link.path"
            class="glass-card-hover px-6 py-3"
          >
            {{ link.name }}
          </router-link>
        </nav>
      </div>
    </header>

    <!-- Stats Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
      <div
        v-for="stat in stats"
        :key="stat.label"
        class="glass-card p-6 shimmer"
      >
        <div class="text-gray-400 text-sm uppercase tracking-wider mb-2">
          {{ stat.label }}
        </div>
        <div class="text-4xl font-bold text-white mb-2">
          {{ stat.value }}
        </div>
        <div class="text-sm" :class="stat.changeClass">
          {{ stat.change }}
        </div>
      </div>
    </div>

    <!-- Main Content Grid -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <!-- Connected Servers -->
      <div class="glass-card p-8">
        <h2 class="text-2xl font-bold mb-6 text-white">Connected Servers</h2>
        <div class="space-y-4">
          <div
            v-for="server in servers"
            :key="server.id"
            class="flex items-center justify-between p-4 rounded-lg bg-white/5 hover:bg-white/10 transition-all"
          >
            <div class="flex items-center gap-4">
              <div
                class="w-3 h-3 rounded-full"
                :class="server.status === 'healthy' ? 'bg-green-500' : 'bg-red-500'"
              ></div>
              <div>
                <div class="font-semibold text-white">{{ server.name }}</div>
                <div class="text-sm text-gray-400">{{ server.type }}</div>
              </div>
            </div>
            <div class="text-sm text-gray-400">
              {{ server.tools }} tools
            </div>
          </div>
        </div>
      </div>

      <!-- Recent Activity -->
      <div class="glass-card p-8">
        <h2 class="text-2xl font-bold mb-6 text-white">Recent Activity</h2>
        <div class="space-y-4">
          <div
            v-for="activity in recentActivity"
            :key="activity.id"
            class="flex items-start gap-4 p-4 rounded-lg bg-white/5"
          >
            <div class="text-2xl">{{ activity.icon }}</div>
            <div class="flex-1">
              <div class="text-white font-medium">{{ activity.title }}</div>
              <div class="text-sm text-gray-400">{{ activity.description }}</div>
              <div class="text-xs text-gray-500 mt-1">{{ activity.time }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="mt-8 flex gap-4">
      <button class="btn-metal-primary flex-1 py-6 text-lg">
        ➕ Register New Server
      </button>
      <button class="btn-metal flex-1 py-6 text-lg">
        🔑 Generate Access Token
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const navLinks = [
  { name: 'Servers', path: '/servers' },
  { name: 'Tools', path: '/tools' },
  { name: 'Tokens', path: '/tokens' }
]

const stats = ref([
  { label: 'Active Servers', value: '3', change: '+2 this week', changeClass: 'text-green-400' },
  { label: 'Available Tools', value: '24', change: '+8 this week', changeClass: 'text-green-400' },
  { label: 'API Calls Today', value: '1.2K', change: '+15%', changeClass: 'text-green-400' },
  { label: 'Avg Response', value: '145ms', change: '-12ms', changeClass: 'text-green-400' }
])

const servers = ref([
  { id: 1, name: 'Weather Server', type: 'SSE', status: 'healthy', tools: 5 },
  { id: 2, name: 'Filesystem Server', type: 'SSE', status: 'healthy', tools: 8 },
  { id: 3, name: 'SQLite Server', type: 'SSE', status: 'healthy', tools: 11 }
])

const recentActivity = ref([
  { id: 1, icon: '✅', title: 'Server Connected', description: 'Weather Server is now online', time: '2 minutes ago' },
  { id: 2, icon: '🔧', title: 'Tool Discovered', description: '5 new tools from Filesystem Server', time: '15 minutes ago' },
  { id: 3, icon: '🔑', title: 'Token Generated', description: 'New API token for user admin', time: '1 hour ago' }
])
</script>
