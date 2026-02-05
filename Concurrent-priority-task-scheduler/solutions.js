class TaskScheduler {
  constructor(concurrency) {
    this.concurrency = concurrency;
  }

  async execute(tasks, priorities) {
    if (tasks.length !== priorities.length) return [];

    const results = new Array(tasks.length);

    const indexedTasks = tasks.map((task, index) => ({
      task,
      priority: priorities[index],
      index,
    }));

    indexedTasks.sort((a, b) => {
      if (b.priority !== a.priority) return b.priority - a.priority;
      return a.index - b.index;
    });

    let cursor = 0;

    const runTask = async () => {
      while (cursor < indexedTasks.length) {
        const { task, index } = indexedTasks[cursor++];

        try {
          const result = await task();
          results[index] = { result, error: null };
        } catch (err) {
          results[index] = { result: null, error: String(err) };
        }
      }
    };

    const workers = Array.from(
      { length: Math.min(this.concurrency, indexedTasks.length) },
      () => runTask()
    );

    await Promise.all(workers);
    return results;
  }
}
