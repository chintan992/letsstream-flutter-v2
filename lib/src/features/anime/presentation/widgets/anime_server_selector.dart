import 'package:flutter/material.dart';
import 'package:lets_stream/src/core/models/anime/anime_server.dart';

/// A bottom sheet widget for selecting anime streaming servers.
///
/// This widget displays available servers grouped by type (Sub/Dub) and allows
/// users to select their preferred server for streaming.
class AnimeServerSelector extends StatelessWidget {
  /// The list of available servers.
  final List<AnimeServer> servers;

  /// The currently selected server.
  final AnimeServer? selectedServer;

  /// The currently selected type ("sub" or "dub").
  final String selectedType;

  /// Callback when a server is selected.
  final void Function(AnimeServer) onServerSelected;

  /// Callback when the type is changed.
  final void Function(String) onTypeChanged;

  /// Creates a new AnimeServerSelector instance.
  const AnimeServerSelector({
    super.key,
    required this.servers,
    this.selectedServer,
    required this.selectedType,
    required this.onServerSelected,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.settings, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Select Server',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          // Type selector
          _buildTypeSelector(),
          
          // Server list
          Flexible(
            child: _buildServerList(),
          ),
        ],
      ),
    );
  }

  /// Builds the type selector (Sub/Dub toggle).
  Widget _buildTypeSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeButton('sub', 'Sub'),
          ),
          Expanded(
            child: _buildTypeButton('dub', 'Dub'),
          ),
        ],
      ),
    );
  }

  /// Builds a type selection button.
  Widget _buildTypeButton(String type, String label) {
    final isSelected = selectedType == type;
    final serversForType = servers.where((s) => s.type == type).toList();
    
    return GestureDetector(
      onTap: serversForType.isNotEmpty ? () => onTypeChanged(type) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${serversForType.length} servers',
              style: TextStyle(
                color: isSelected ? Colors.white70 : Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the server list for the selected type.
  Widget _buildServerList() {
    final serversForType = servers.where((s) => s.type == selectedType).toList();
    
    if (serversForType.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No $selectedType servers available',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: serversForType.length,
      itemBuilder: (context, index) {
        final server = serversForType[index];
        final isSelected = selectedServer?.serverId == server.serverId;
        
        return _buildServerItem(server, isSelected);
      },
    );
  }

  /// Builds a server list item.
  Widget _buildServerItem(AnimeServer server, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? Colors.blue[50] : Colors.white,
      ),
      child: ListTile(
        onTap: () {
          onServerSelected(server);
        },
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.play_circle_outline,
            color: isSelected ? Colors.white : Colors.grey[600],
            size: 24,
          ),
        ),
        title: Text(
          server.serverName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.blue[800] : Colors.black87,
          ),
        ),
        subtitle: Text(
          _getServerDescription(server),
          style: TextStyle(
            color: isSelected ? Colors.blue[600] : Colors.grey[600],
          ),
        ),
        trailing: isSelected
            ? const Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 24,
              )
            : Icon(
                Icons.radio_button_unchecked,
                color: Colors.grey[400],
                size: 24,
              ),
      ),
    );
  }

  /// Gets a description for the server.
  String _getServerDescription(AnimeServer server) {
    final typeLabel = server.isSub ? 'Subtitled' : 'Dubbed';
    
    // Try to determine quality from server name
    if (server.serverName.toLowerCase().contains('hd')) {
      return '$typeLabel • HD Quality';
    } else if (server.serverName.toLowerCase().contains('4k')) {
      return '$typeLabel • 4K Quality';
    } else if (server.serverName.toLowerCase().contains('sd')) {
      return '$typeLabel • SD Quality';
    }
    
    return typeLabel;
  }

  /// Shows the server selector as a modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required List<AnimeServer> servers,
    AnimeServer? selectedServer,
    required String selectedType,
    required void Function(AnimeServer) onServerSelected,
    required void Function(String) onTypeChanged,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AnimeServerSelector(
        servers: servers,
        selectedServer: selectedServer,
        selectedType: selectedType,
        onServerSelected: onServerSelected,
        onTypeChanged: onTypeChanged,
      ),
    );
  }
}
