$(document).ready(function() {
  var form = document.querySelector("#new_payment");
  var client_token = document.getElementById("client_token").innerHTML;

  braintree.dropin.create(
    {
      authorization: client_token,
      container: "#dropin-container"
    },
    function(createErr, instance) {
      form.addEventListener("submit", function(event) {
        event.preventDefault();

        instance.requestPaymentMethod(function(err, payload) {
          if (err) {
            console.log("Error", err);
            return;
          }

          // Add the nonce to the form and submit
          document.querySelector("#nonce").value = payload.nonce;
          form.submit();
          $(".contact-form-submit-button").button("loading");
        });
      });
    }
  );
});
