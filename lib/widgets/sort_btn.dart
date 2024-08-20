import 'package:flutter/material.dart';

class SortFilterBottomSheet extends StatefulWidget {
  const SortFilterBottomSheet({super.key});
  @override
  _SortFilterBottomSheetState createState() => _SortFilterBottomSheetState();
}

class _SortFilterBottomSheetState extends State<SortFilterBottomSheet> {
  int _sortByValue = -1; // Default value for "Sort by"
  final Map<String, bool> _selectedCategories = {
    'Fruits & Vegetable': false,
    'Baby Care': false,
    'Household & Cleaning': false,
    'Meat & Fish': false,
    'Stationary': false,
    'Personal Care': false,
  };
  int _priceRangeValue = 1; // Default value for "Price range"

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            _buildSortBySection(),
            _buildCategoriesSection(),
            _buildPriceSection(),
            const SizedBox(height: 20),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48), // Placeholder to balance the title
          const Text(
            'Sort & Filters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSortBySection() {
    return ExpansionTile(
      title: const Text('Sort by'),
      children: [
        RadioListTile(
          title: const Text('Highest Rating'),
          value: 1,
          groupValue: _sortByValue,
          onChanged: (value) {
            setState(() {
              _sortByValue = value!;
            });
          },
        ),
        RadioListTile(
          title: const Text('Newest'),
          value: 2,
          groupValue: _sortByValue,
          onChanged: (value) {
            setState(() {
              _sortByValue = value!;
            });
          },
        ),
        RadioListTile(
          title: const Text('Lowest Price'),
          value: 3,
          groupValue: _sortByValue,
          onChanged: (value) {
            setState(() {
              _sortByValue = value!;
            });
          },
        ),
        RadioListTile(
          title: const Text('Best Seller'),
          value: 4,
          groupValue: _sortByValue,
          onChanged: (value) {
            setState(() {
              _sortByValue = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return ExpansionTile(
      title: const Text('Categories'),
      children: _selectedCategories.keys.map((String key) {
        return CheckboxListTile(
          title: Text(key),
          value: _selectedCategories[key],
          onChanged: (bool? value) {
            setState(() {
              _selectedCategories[key] = value!;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildPriceSection() {
    return ExpansionTile(
      title: const Text('Price'),
      children: [
        RadioListTile(
          title: const Text('৳ 0 - ৳ 100'),
          value: 1,
          groupValue: _priceRangeValue,
          onChanged: (value) {
            setState(() {
              _priceRangeValue = value!;
            });
          },
        ),
        RadioListTile(
          title: const Text('৳ 100 - ৳ 200'),
          value: 2,
          groupValue: _priceRangeValue,
          onChanged: (value) {
            setState(() {
              _priceRangeValue = value!;
            });
          },
        ),
        RadioListTile(
          title: const Text('৳ 200+'),
          value: 3,
          groupValue: _priceRangeValue,
          onChanged: (value) {
            setState(() {
              _priceRangeValue = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 100.0),
          ),
          child: const Text(
            'Apply',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _sortByValue = -1;
              _selectedCategories.updateAll((key, value) => false);
              _priceRangeValue = -1;
            });
          },
          child: const Text(
            'Clear',
            style: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
