Test Case 1: Basic Priority Scheduling

text
Input:
concurrency = 2
tasks = [
  () => new Promise(res => setTimeout(() => res('A'), 300)),
  () => new Promise(res => setTimeout(() => res('B'), 200)),
  () => new Promise(res => setTimeout(() => res('C'), 100)),
  () => new Promise(res => setTimeout(() => res('D'), 400))
]
priorities = [1, 3, 2, 1]

Output:
[
  {result: 'A', error: null},
  {result: 'B', error: null},
  {result: 'C', error: null},
  {result: 'D', error: null}
]
Test Case 2: Error Handling

text
Input:
concurrency = 1
tasks = [
  () => Promise.resolve('Success'),
  () => Promise.reject('Task failed'),
  () => Promise.resolve('Another success')
]
priorities = [2, 1, 3]

Output:
[
  {result: 'Success', error: null},
  {result: null, error: 'Task failed'},
  {result: 'Another success', error: null}
]
Test Case 3: Equal Priorities (Stable Sort)

text
Input:
concurrency = 2
tasks = [
  () => Promise.resolve('First'),
  () => Promise.resolve('Second'),
  () => Promise.resolve('Third')
]
priorities = [1, 1, 1]

Output:
[
  {result: 'First', error: null},
  {result: 'Second', error: null},
  {result: 'Third', error: null}
]
Test Case 4: Single Concurrency (Sequential)

text
Input:
concurrency = 1
tasks = [
  () => Promise.resolve('A'),
  () => Promise.resolve('B'),
  () => Promise.resolve('C')
]
priorities = [3, 1, 2]

Output:
[
  {result: 'A', error: null},
  {result: 'B', error: null},
  {result: 'C', error: null}
]
Test Case 5: Mixed Errors and Success

text
Input:
concurrency = 2
tasks = [
  () => Promise.resolve('OK1'),
  () => Promise.reject('Error1'),
  () => Promise.resolve('OK2'),
  () => Promise.reject('Error2'),
  () => Promise.resolve('OK3')
]
priorities = [2, 3, 1, 4, 2]

Output:
[
  {result: 'OK1', error: null},
  {result: null, error: 'Error1'},
  {result: 'OK2', error: null},
  {result: null, error: 'Error2'},
  {result: 'OK3', error: null}
]
Test Case 6: Empty Input

text
Input:
concurrency = 5
tasks = []
priorities = []

Output:
[]
Test Case 7: Concurrency Limit > Tasks

text
Input:
concurrency = 10
tasks = [
  () => Promise.resolve('A'),
  () => Promise.resolve('B'),
  () => Promise.resolve('C')
]
priorities = [1, 2, 3]

Output:
[
  {result: 'A', error: null},
  {result: 'B', error: null},
  {result: 'C', error: null}
]
Test Case 8: High Priority Always First

text
Input:
concurrency = 2
tasks = [
  () => new Promise(res => setTimeout(() => res('Low1'), 100)),
  () => new Promise(res => setTimeout(() => res('High'), 50)),
  () => new Promise(res => setTimeout(() => res('Low2'), 100))
]
priorities = [1, 10, 1]

Output:
[
  {result: 'Low1', error: null},
  {result: 'High', error: null},
  {result: 'Low2', error: null}
]
Test Case 9: Array Length Mismatch

text
Input:
concurrency = 3
tasks = [
  () => Promise.resolve('A'),
  () => Promise.resolve('B')
]
priorities = [1, 2, 3]  // Extra priority value

Output:
[]
Test Case 10: Negative and Zero Priorities

text
Input:
concurrency = 2
tasks = [
  () => Promise.resolve('Negative'),
  () => Promise.resolve('Zero'),
  () => Promise.resolve('Positive')
]
priorities = [-5, 0, 3]

Output:
[
  {result: 'Negative', error: null},
  {result: 'Zero', error: null},
  {result: 'Positive', error: null}
]