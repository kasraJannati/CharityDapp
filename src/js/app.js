App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',
  minAmount: 0 ,

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    if (typeof web3 !== 'undefined') {
      // If a web3 instance is already provided by Meta Mask.
      
      window.ethereum.enable()
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      web3 = new Web3(App.web3Provider);
    }
    return App.initContract();
  },

  initContract: function() {
    $.getJSON("CharityApp.json", function(CharityApp) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.CharityApp = TruffleContract(CharityApp);
      // Connect provider to interact with contract
      App.contracts.CharityApp.setProvider(App.web3Provider);
      App.contracts.CharityApp.deployed().then(instance=>{
        console.log(instance)
        instance.minAmount.call().then(amount => {
          App.minAmount = Number(amount)
        })
      
    
      })
      return App.render();
    });
  },

  render: async function() {
    var electionInstance;
    var loader = $("#loader");
    var content = $("#content");

    loader.show();
    content.hide();

    // Load account data
    App.account=web3.eth.accounts[0];    
    $("#accountAddress").html("Your Account: " + App.account);


    // Load contract data
    App.contracts.CharityApp.deployed().then(function(instance) {
      
      document.getElementById("btnAmount").addEventListener('click',function(){
        let amount = document.getElementById("inputAmount").value;
        amount = Number(amount);
        if(amount >= App.minAmount){


          App.contracts.CharityApp.deployed().then(instance=>{
        
            instance.donate(App.account,{value: amount}).then(txHash => {
              console.log(txHash)
           } )})



        }
        else{
          alert('should be bigger than minimum amount:' + App.minAmount)
        }
      });

      loader.hide();
      content.show();
    }).catch(function(error) {
      console.warn(error);
    });
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});