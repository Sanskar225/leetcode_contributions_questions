class TaskScheduler {
  constructor(concurrency) {
    this.limit = concurrency;
  }

  async execute(tasks, priorities) {
    if (tasks.length !== priorities.length) return [];
    
    const n = tasks.length;
    const results = new Array(n).fill(null);
    
    // Create and sort task list
    const taskList = tasks.map((task, i) => ({ task, priority: priorities[i], index: i }));
    taskList.sort((a, b) => b.priority - a.priority || a.index - b.index);
    
    // Process in batches respecting concurrency limit
    for (let i = 0; i < n; i += this.limit) {
      const batch = taskList.slice(i, i + this.limit);
      const promises = batch.map(async ({ task, index }) => {
        try {
          const result = await task();
          return { index, result, error: null };
        } catch (error) {
          return { index, result: null, error: String(error) };
        }
      });
      
      const batchResults = await Promise.all(promises);
      batchResults.forEach(({ index, result, error }) => {
        results[index] = { result, error };
      });
    }
    
    return results;
  }
}