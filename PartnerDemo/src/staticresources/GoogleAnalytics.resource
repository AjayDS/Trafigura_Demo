// hide sidebar component that embedded this javascript
  $("h2:contains('Google Analytics')").parent().parent().hide();

  // Google Universal Analytics (provided by google)
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  // Our analytics tracking id for salesforce production.
  // We also enabled cross-domain linking plugins to try
  // and handle that salesforce uses multiple sub-domains
  // to render standard and visualforce content; we don't
  // want the bounce arounds to be treated as separate "users"
  // in the analytics reporting.
  ga('create', 'UA-86132010-1', 'auto', {
    'allowLinker': true
  });
  ga('require', 'linkid', 'linkid.js');
  ga('require', 'linker');
  ga('linker:autoLink', [/harmancommunities--c.na30.visual.force.com(\.|--)(.)*\.(salesforce|force)\.com/]);
  ga('send', 'pageview');