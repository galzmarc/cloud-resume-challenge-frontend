const endpoint = "https://6pszd46z5a.execute-api.eu-west-1.amazonaws.com/dev/";

// Put data to the DynamoDB table
async function addVisitor() {
  try {
    const response = await fetch(endpoint, {
      method: "PUT",
      mode: "cors",
    });
    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }
    console.log(response.json())
    return
  } catch (err) {
    console.log(err);
  }
}

// Get data from the DynamoDB table
async function getVisitors() {
  try {
    await addVisitor();
    const response = await fetch(endpoint, {
      method: "GET",
      mode: "cors",
    });
    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }
    const data = await response.json();
    return data
  } catch (err) {
    console.log(err);
  }
}

// Updates the HTML with the counter value
async function updateCounter() {
  const counter = await getVisitors();
  const visits = document.getElementById('visits');
	visits.textContent = `${counter}`;
}

updateCounter();

module.exports = {
  getVisitors,
};