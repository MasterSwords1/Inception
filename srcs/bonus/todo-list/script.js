const inputEl = document.getElementById("task-input");
const taskContainer = document.getElementById("tasks-container");


function addTask(e)
{
  task = inputEl.value;
  const HTMLString = `
  <div class="task">
      <p>${task}</p>
      <button class="del-button">Delete</button>
    </div>`
  taskContainer.insertAdjacentHTML('beforeend', HTMLString);
  const tasks = document.querySelectorAll(".del-button")
  tasks.forEach(el => {
    console.log(el)
    el.addEventListener("click", (e) => {e.target.parentNode.remove()})
  })
  inputEl.value = ""
  e.preventDefault()
}

const addButton = document.getElementById("add-button")

addButton.addEventListener("click", addTask)
