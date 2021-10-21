import 'dart:io';
import 'package:puppeteer/puppeteer.dart';
import 'package:sprintf/sprintf.dart';

void main() async {
  // Start the browser and go to a web page
  var browser = await puppeteer.launch();
  final list = <String>[
    "who_we_are.html",
    "whatis.html",
    "whatsnew.html",
    "key_concepts.html",
    "blockchain.html",
    "fabric_model.html",
    "network/network.html",
    "identity/identity.html",
    "membership/membership.html",
    "policies/policies.html",
    "peers/peers.html",
    "smartcontract/smartcontract.html",
    "ledger/ledger.html",
    "orderer/ordering_service.html",
    "private-data/private-data.html",
    "capabilities_concept.html",
    "usecases.html",
    "getting_started.html",
    "prereqs.html",
    "install.html",
    "test_network.html",
    "developapps/developing_applications.html",
    "developapps/scenario.html",
    "developapps/analysis.html",
    "developapps/architecture.html",
    "developapps/smartcontract.html",
    "developapps/application.html",
    "developapps/designelements.html",
    "developapps/contractname.html",
    "developapps/chaincodenamespace.html",
    "developapps/transactioncontext.html",
    "developapps/transactionhandler.html",
    "developapps/endorsementpolicies.html",
    "developapps/connectionprofile.html",
    "developapps/connectionoptions.html",
    "developapps/wallet.html",
    "developapps/gateway.html",
    "tutorials.html",
    "deploy_chaincode.html",
    "write_first_app.html",
    "tutorial/commercial_paper.html",
    "private_data_tutorial.html",
    "couchdb_tutorial.html",
    "create_channel/create_channel_overview.html",
    "create_channel/create_channel.html",
    "create_channel/create_channel_config.html",
    "create_channel/channel_policies.html",
    "channel_update_tutorial.html",
    "config_update.html",
    "chaincode4ade.html",
    "videos.html",
    "deployment_guide_overview.html",
    "ops_guide.html",
    "orderer_deploy.html",
    "msp.html",
    "hsm.html",
    "configtx.html",
    "endorsement-policies.html",
    "pluggable_endorsement_and_validation.html",
    "access_control.html",
    "idemix.html",
    "idemixgen.html",
    "operations_service.html",
    "metrics_reference.html",
    "cc_launcher.html",
    "cc_service.html",
    "error-handling.html",
    "logging-control.html",
    "enable_tls.html",
    "raft_configuration.html",
    "kafka_raft_migration.html",
    "kafka.html",
    "upgrade.html",
    "upgrade_to_newest_version.html",
    "upgrading_your_components.html",
    "updating_capabilities.html",
    "enable_cc_lifecycle.html",
    "command_ref.html",
    "commands/peercommand.html",
    "commands/peerchaincode.html",
    "commands/peerlifecycle.html",
    "commands/peerchannel.html",
    "commands/peerversion.html",
    "commands/peernode.html",
    "commands/configtxgen.html",
    "commands/configtxlator.html",
    "commands/cryptogen.html",
    "discovery-cli.html",
    "commands/fabric-ca-commands.html",
    "architecture.html",
    "fabric-sdks.html",
    "txflow.html",
    "discovery-overview.html",
    "capability_requirements.html",
    "channels.html",
    "couchdb_as_state_database.html",
    "peer_event_services.html",
    "private-data-arch.html",
    "readwrite.html",
    "gossip.html",
    "Fabric-FAQ.html",
    "CONTRIBUTING.html",
    "docs_guide.html",
    "international_languages.html",
    "style_guide.html",
    "jira_navigation.html",
    "dev-setup/devenv.html",
    "dev-setup/build.html",
    "style-guides/go-style.html",
    "glossary.html",
    "releases.html",
    "questions.html",
    "status.html"
  ];

  var pdfnames = <String>[];
  int index = 0;
  for (int i = 0; i < list.length; i++) {
    if (index == list.length - 1) break;
    final name = sprintf('%03d.pdf', [index++]);
    pdfnames.add(name);
    // await makePdf(
    //     browser,
    //     'https://hyperledger-fabric.readthedocs.io/zh_CN/release-2.2/${list[index]}',
    //     name);
  }

  var args = [
    'merge',
    '-m',
    'create',
    '-s',
    'output.pdf',
  ];

  args.addAll(pdfnames);

  var result = await Process.run('pdfcpu', args);
  stdout.write(result.stdout);
  stderr.write(result.stderr);

  await browser.close();
}

Future<void> makePdf(Browser browser, String url, String name) async {
  var page = await browser.newPage();
  await page.goto(url, wait: Until.networkIdle);

  // For this example, we force the "screen" media-type because sometime
  // CSS rules with "@media print" can change the look of the page.
  await page.emulateMediaType(MediaType.screen);

  await page.evaluate('''
    // 删除顶部
    // 拿到待删除节点:
    var self = document.querySelector('body > div.wy-grid-for-nav > section > div > div > div:nth-child(1)');
    // 拿到父节点:
    var parent = self.parentElement;
    // 删除:
    parent.removeChild(self);

    // 删除底部
    var self_foot = document.querySelector('body > div.wy-grid-for-nav > section > div > div > footer');
    // 拿到父节点:
    var _parent = self_foot.parentElement;
    // 删除:
    _parent.removeChild(self_foot);

    // 删除导航
    var selfnav = document.querySelector('body > div.wy-grid-for-nav > section > nav');
    // 拿到父节点:
    var _parentnav = selfnav.parentElement;
    // 删除:
    _parentnav.removeChild(selfnav);
  ''');

  // Capture the PDF and save it to a file.
  await page.pdf(
      format: PaperFormat.a4,
      printBackground: true,
      // pageRanges: '1',
      output: File(name).openWrite());
}
