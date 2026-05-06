import 'package:flutter/material.dart';
import 'package:mgpx_app/pages/login_screen.dart';
import 'package:mgpx_app/services/auth_storage.dart';
import 'package:mgpx_app/widgets/custom_bottom_nav_bar.dart';
import 'package:mgpx_app/widgets/dashboard_section_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isSigningOut = false;
  final AuthStorage _authStorage = AuthStorage();

  static const List<String> _titles = [
    'MGPX APP',
    'Leads',
    'Perfil',
  ];

  void _onNavTap(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() => _selectedIndex = index);
  }

  Future<void> _signOut() async {
    if (_isSigningOut) {
      return;
    }

    setState(() => _isSigningOut = true);
    try {
      await _authStorage.clearSession();
      if (!mounted) {
        return;
      }

      await Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.routeName,
        (route) => false,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _isSigningOut = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nao foi possivel sair. Tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const _HomeTab(),
          const _LeadsScreen(),
          _ProfileScreen(
            onSignOut: _signOut,
            isSigningOut: _isSigningOut,
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  static const List<_LeadNovo> _leadsNovos = [
    _LeadNovo(
      nome: 'Carlos Mendes',
      origem: 'WhatsApp',
      horario: '09:15',
      status: 'Novo',
    ),
    _LeadNovo(
      nome: 'Ana Paula',
      origem: 'Indicacao',
      horario: '10:40',
      status: 'Novo',
    ),
    _LeadNovo(
      nome: 'Pedro Lima',
      origem: 'Site',
      horario: '11:20',
      status: 'Novo',
    ),
  ];

  static const List<_MeuLead> _meusLeads = [
    _MeuLead(
      nome: 'Joao Silva',
      status: 'Em negociacao',
      atualizacao: 'Atualizado ontem',
    ),
    _MeuLead(
      nome: 'Empresa XPTO',
      status: 'Visita hoje as 14h',
      atualizacao: 'Hoje as 09h',
    ),
    _MeuLead(
      nome: 'Maria Souza',
      status: 'Aguardando retorno',
      atualizacao: 'Ha 2 dias',
    ),
    _MeuLead(
      nome: 'Cliente Alfa',
      status: 'Proposta enviada',
      atualizacao: 'Hoje as 08h',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        const _IndicatorsGrid(),
        const SizedBox(height: 16),
        DashboardSectionCard(
          title: 'Leads novos',
          child: Column(
            children: _leadsNovos
                .map(
                  (lead) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _LeadNovoCard(lead: lead),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        DashboardSectionCard(
          title: 'Meus leads',
          child: Column(
            children: _meusLeads
                .map(
                  (lead) => _MeuLeadTile(lead: lead),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _LeadsScreen extends StatelessWidget {
  const _LeadsScreen();

  static const List<_LeadResumo> _leads = [
    _LeadResumo(nome: 'Lojas Andrade', etapa: 'Contato inicial', origem: 'Site'),
    _LeadResumo(nome: 'Bianca Nunes', etapa: 'Reuniao agendada', origem: 'WhatsApp'),
    _LeadResumo(nome: 'Mercado Sol', etapa: 'Proposta enviada', origem: 'Indicacao'),
    _LeadResumo(nome: 'Diego Mota', etapa: 'Aguardando retorno', origem: 'Instagram'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      itemBuilder: (context, index) {
        final lead = _leads[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.colorScheme.surface,
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(Icons.apartment, color: theme.colorScheme.onPrimaryContainer),
            ),
            title: Text(
              lead.nome,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('${lead.etapa}\nOrigem: ${lead.origem}'),
            isThreeLine: true,
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: _leads.length,
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen({
    required this.onSignOut,
    required this.isSigningOut,
  });

  final Future<void> Function() onSignOut;
  final bool isSigningOut;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 110),
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.person,
            size: 44,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Vendedor MGPX',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'vendedor@mgpx.com',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 20),
        DashboardSectionCard(
          title: 'Conta',
          child: Column(
            children: [
              const _ProfileOptionTile(
                icon: Icons.badge_outlined,
                title: 'Dados cadastrais',
                subtitle: 'Atualize nome e telefone',
              ),
              const _ProfileOptionTile(
                icon: Icons.lock_outline,
                title: 'Seguranca',
                subtitle: 'Altere senha e controle de acesso',
              ),
              const _ProfileOptionTile(
                icon: Icons.notifications_none,
                title: 'Notificacoes',
                subtitle: 'Gerencie avisos de leads e visitas',
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isSigningOut ? null : onSignOut,
                  icon: isSigningOut
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout),
                  label: Text(isSigningOut ? 'Saindo...' : 'Sair'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(color: theme.colorScheme.error.withOpacity(0.4)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileOptionTile extends StatelessWidget {
  const _ProfileOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}

class _IndicatorsGrid extends StatelessWidget {
  const _IndicatorsGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 520;

        if (isWide) {
          return const Row(
            children: [
              Expanded(
                child: _IndicatorCard(
                  label: 'Leads em andamento',
                  value: '12',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _IndicatorCard(
                  label: 'Leads novos no dia',
                  value: '5',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _IndicatorCard(
                  label: 'Visitas marcadas',
                  value: '3',
                ),
              ),
            ],
          );
        }

        return const Column(
          children: [
            _IndicatorCard(
              label: 'Leads em andamento',
              value: '12',
            ),
            SizedBox(height: 10),
            _IndicatorCard(
              label: 'Leads novos no dia',
              value: '5',
            ),
            SizedBox(height: 10),
            _IndicatorCard(
              label: 'Visitas marcadas',
              value: '3',
            ),
          ],
        );
      },
    );
  }
}

class _IndicatorCard extends StatelessWidget {
  const _IndicatorCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}

class _LeadNovoCard extends StatelessWidget {
  const _LeadNovoCard({
    required this.lead,
  });

  final _LeadNovo lead;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  lead.nome,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Chip(
                label: Text(lead.status),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('Origem: ${lead.origem}'),
          Text('Horario: ${lead.horario}'),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Contato'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeuLeadTile extends StatelessWidget {
  const _MeuLeadTile({
    required this.lead,
  });

  final _MeuLead lead;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: ListTile(
        title: Text(lead.nome),
        subtitle: Text('${lead.status}\n${lead.atualizacao}'),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _LeadNovo {
  const _LeadNovo({
    required this.nome,
    required this.origem,
    required this.horario,
    required this.status,
  });

  final String nome;
  final String origem;
  final String horario;
  final String status;
}

class _MeuLead {
  const _MeuLead({
    required this.nome,
    required this.status,
    required this.atualizacao,
  });

  final String nome;
  final String status;
  final String atualizacao;
}

class _LeadResumo {
  const _LeadResumo({
    required this.nome,
    required this.etapa,
    required this.origem,
  });

  final String nome;
  final String etapa;
  final String origem;
}
